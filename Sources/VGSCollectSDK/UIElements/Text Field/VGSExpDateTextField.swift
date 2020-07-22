//
//  Copyright © 2020 VGS. All rights reserved.
//

import Foundation
import UIKit

/// An object that displays an editable text area. Can be use instead of a `VGSTextField` when need to show picker view with Card Number expiration month and year.
public final class VGSExpDateTextField: VGSTextField {
    
    /// Available Month Label formats in UIPickerView
    public enum MonthFormat {
      /// Shot month name, ex: Jan
      case shortSymbols
      /// Long month name, ex: January
      case longSymbols
      /// Month number: 01
      case numbers
    }
  
    /// Available Year Label formats in UIPickerView
    public enum YearFormat {
      /// Two digits year format: 21
      case short
      /// Four digits year format: 2021
      case long
    }
    
    /// UIPickerView Month Label format
    public var monthPickerFormat: MonthFormat = .longSymbols {
      didSet {
        updateMonthsDataSource()
      }
    }
  
    /// UIPickerView Year Label format
    public var yearPickerDateFormat: YearFormat = .long {
        didSet {
          updateYearsDataSource()
        }
    }
    
    ///:nodoc:
    public override var configuration: VGSConfiguration? {
        didSet {
            fieldType = .expDate
        }
    }
  
    /// Visual month data source
    internal var monthsDataSource = [String]()
    /// Visual year data source
    internal var yearsDataSource = [String]()
    /// Valid months range
    internal lazy var months = Array(1...12)
    /// Valid years range
    internal lazy var years: [Int] = {
      let current = Calendar.currentYear
      return Array(current...(current + validYearsCount))
    }()
    internal let monthPickerComponent = 0
    internal let yearPickerComponent = 1
    internal let validYearsCount = 20
    internal lazy var picker = self.makePicker()
        
    // MARK: - Initialization
  
    override func mainInitialization() {
      super.mainInitialization()
      textField.inputView = picker
      updateYearsDataSource()
      updateMonthsDataSource()
      scrollToCurrentMonth(animated: false)
      textField.inputAccessoryView = UIView()
    }
        
    private func updateTextField() {
      let month = months[picker.selectedRow(inComponent: monthPickerComponent)]
      let year = years[picker.selectedRow(inComponent: yearPickerComponent)]
      let format = textField.formatPattern.components(separatedBy: "/").last ?? FieldType.expDate.defaultFormatPattern
      let yearString = (format.count == 4) ? String(year) : String(year - 2000)
      let monthString = String(format: "%02d", month)
      self.setText("\(monthString)\(yearString)")
    }
}

extension VGSExpDateTextField: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case monthPickerComponent:
            return monthsDataSource.count
        default:
            return yearsDataSource.count
        }
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case monthPickerComponent:
            return monthsDataSource[row]
        default:
            return yearsDataSource[row]
        }
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      /// check that date is not before current date
      let currentMonthIndex = Calendar(identifier: .gregorian).component(.month, from: Date()) - 1
      if pickerView.selectedRow(inComponent: yearPickerComponent) == 0 && pickerView.selectedRow(inComponent: monthPickerComponent) < currentMonthIndex {
        pickerView.selectRow(currentMonthIndex, inComponent: monthPickerComponent, animated: true)
      }
      updateTextField()
    }
}

private extension VGSExpDateTextField {
    func makePicker() -> UIPickerView {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }
  
    func updateMonthsDataSource() {
      switch monthPickerFormat {
      case .shortSymbols:
        monthsDataSource = DateFormatter().shortMonthSymbols
      case .longSymbols:
        monthsDataSource = DateFormatter().monthSymbols
      case .numbers:
        monthsDataSource =  months.map{ (String(format: "%02d", $0))}
      }
    }
    
    func updateYearsDataSource() {
      let suffixLength = yearPickerDateFormat == .short ? 2 : 4
      yearsDataSource = years.map{ String(String($0).suffix(suffixLength))}
    }
  
    func scrollToCurrentMonth(animated: Bool) {
      let currentMonthIndex = Calendar.currentMonth - 1
      picker.selectRow(currentMonthIndex, inComponent: monthPickerComponent, animated: animated)
      picker.selectRow(0, inComponent: yearPickerComponent, animated: animated)
    }
}

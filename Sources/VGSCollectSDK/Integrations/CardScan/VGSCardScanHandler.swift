//
//  VGSCardScanHandler.swift
//  VGSCollectSDK
//
//  Created by Dima on 14.07.2020.
//  Copyright © 2020 VGS. All rights reserved.
//


import Foundation
#if canImport(UIKit)
import UIKit
#endif

#if canImport(CardScan)
import CardScan

internal class VGSCardScanHandler: NSObject, VGSCardScanHandlerProtocol {
    
    weak var delegate: VGSCardScanControllerDelegate?
    weak var view: UIViewController?
    
    func presentScanVC(on viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        guard let vc = ScanViewController.createViewController(withDelegate: self) else {
            print("This device is incompatible with CardScan")
            return
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.view = vc
        viewController.present(vc, animated: animated, completion: completion)
    }
    
    func dismissScanVC(animated: Bool, completion: (() -> Void)?) {
        view?.dismiss(animated: animated, completion: completion)
    }
}

/// :nodoc:
extension VGSCardScanHandler: ScanDelegate {
    
    func userDidSkip(_ scanViewController: ScanViewController) {
          delegate?.userDidCancelScan?()
    }
      
    func userDidCancel(_ scanViewController: ScanViewController) {
       delegate?.userDidCancelScan?()
    }
      
    func userDidScanCard(_ scanViewController: ScanViewController, creditCard: CreditCard) {
      guard let cardIOdelegate = delegate else {
         delegate?.userDidFinishScan?()
         return
      }
      
      let number = creditCard.number
      let expiryMonth = creditCard.expiryMonth
      let expiryYear = creditCard.expiryYear
      
      if !creditCard.number.isEmpty, let textfield = cardIOdelegate.textFieldForScannedData(type: .cardNumber) {
          textfield.setText(creditCard.number)
      }
//      if  1...12 ~= Int(creditCard.expiryMonth), creditCard.expiryYear >= 2020 {
//        let monthString = Int(creditCard.expiryMonth) < 10 ? "0\(creditCard.expiryMonth)" : "\(creditCard.expiryMonth)"
//        if let textfield = cardIOdelegate.textFieldForScannedData(type: .expirationDate) {
//          let yy = "\(creditCard.expiryYear)".suffix(2)
//          textfield.setText("\(monthString)\(yy)")
//        }
//        if let textfield = cardIOdelegate.textFieldForScannedData(type: .expirationDateLong) {
//          textfield.setText("\(monthString)\(creditCard.expiryYear)")
//        }
//      }
//      if 1...12 ~= Int(creditCard.expiryMonth), let textfield = cardIOdelegate.textFieldForScannedData(type: .expirationMonth) {
//          let monthString = Int(creditCard.expiryMonth) < 10 ? "0\(creditCard.expiryMonth)" : "\(creditCard.expiryMonth)"
//          textfield.setText(monthString)
//      }
//      if creditCard.expiryYear >= 2020 {
//        if let textfield = cardIOdelegate.textFieldForScannedData(type: .expirationYear) {
//          let yy = String("\(creditCard.expiryYear)".suffix(2))
//          textfield.setText(yy)
//        }
//        if let textfield = cardIOdelegate.textFieldForScannedData(type: .expirationYearLong) {
//          let yy = String("\(creditCard.expiryYear)")
//          textfield.setText(yy)
//        }
//      }
//      if let cvc = creditCard.cvv, !cvc.isEmpty, let textfield = cardIOdelegate.textFieldForScannedData(type: .cvc) {
//          textfield.setText(cvc)
//      }
      cardIOdelegate.userDidFinishScan?()
    }
}
#endif

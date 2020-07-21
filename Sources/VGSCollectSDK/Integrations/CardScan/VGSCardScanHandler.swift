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
      guard let cardScanDelegate = delegate else {
         return
      }
      
      if !creditCard.number.isEmpty, let textfield = cardScanDelegate.textFieldForScannedData(type: .cardNumber) {
          textfield.setText(creditCard.number)
      }
      if let month = Int(creditCard.expiryMonth ?? ""), 1...12 ~= month, let year = Int(creditCard.expiryYear ?? ""), year >= 20 {
        if let textfield = cardScanDelegate.textFieldForScannedData(type: .expirationDate) {
          textfield.setText("\(month)\(year)")
        }
        if let textfield = cardScanDelegate.textFieldForScannedData(type: .expirationDateLong) {
          let longYear = "20\(year)"
          textfield.setText("\(month)\(longYear)")
        }
      }
      if let month = Int(creditCard.expiryMonth ?? ""), 1...12 ~= month, let textfield = cardScanDelegate.textFieldForScannedData(type: .expirationMonth) {
          textfield.setText("\(month)")
      }
      if let year = Int(creditCard.expiryYear ?? ""), year >= 20 {
        if let textfield = cardScanDelegate.textFieldForScannedData(type: .expirationYear) {
          textfield.setText("\(year)")
        }
        if let textfield = cardScanDelegate.textFieldForScannedData(type: .expirationYearLong) {
          let longYear = "20\(year)"
          textfield.setText("\(longYear)")
        }
      }
      cardScanDelegate.userDidFinishScan?()
    }
}
#endif

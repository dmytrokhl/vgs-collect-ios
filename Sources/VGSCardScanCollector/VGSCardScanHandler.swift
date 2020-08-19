//
//  VGSCardScanHandler.swift
//  VGSCardScanCollector
//
//  Created by Dima on 18.08.2020.
//  Copyright © 2020 VGS. All rights reserved.
//

import Foundation
import CardScan
#if !COCOAPODS
import VGSCollectSDK
#endif

internal class VGSCardScanHandler: NSObject, VGSScanHandlerProtocol {
    
    weak var delegate: VGSCardScanControllerDelegate?
    weak var view: UIViewController?
    
    func presentScanVC(on viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
//        guard let vc = CardIOPaymentViewController(paymentDelegate: self, scanningEnabled: true, preferredDevicePosition: cameraPosition ?? .unspecified) else {
//            print("This device is not compatible with CardIO")
//            return
//        }
//        vc.hideCardIOLogo = true
//        vc.modalPresentationStyle = .overCurrentContext
//        self.view = vc
//        viewController.present(vc, animated: animated, completion: completion)
        guard let vc = ScanViewController.createViewController(withDelegate: self) else {
            print("This device is incompatible with CardScan")
            return
        }
        self.view = vc
        viewController.present(vc, animated: true)
    }
    
    func dismissScanVC(animated: Bool, completion: (() -> Void)?) {
        view?.dismiss(animated: animated, completion: completion)
    }
}

/// :nodoc:
extension VGSCardScanHandler: ScanDelegate {
  func userDidCancel(_ scanViewController: ScanViewController) {
    print("userDidSkip")
  }
  
  func userDidScanCard(_ scanViewController: ScanViewController, creditCard: CreditCard) {
    print(creditCard.number)
  }
  
  func userDidSkip(_ scanViewController: ScanViewController) {
    print("userDidSkip")
  }
  
    
//    /// :nodoc:
//    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
//        delegate?.userDidCancelScan?()
//    }
//
//    /// :nodoc:
//    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
//        guard let cardInfo = cardInfo, let cardIOdelegate = delegate else {
//            delegate?.userDidFinishScan?()
//            return
//        }
//        if !cardInfo.cardNumber.isEmpty, let textfield = cardIOdelegate.textFieldForScannedData(type: .cardNumber) {
//            textfield.setText(cardInfo.cardNumber)
//        }
//        if  1...12 ~= Int(cardInfo.expiryMonth), cardInfo.expiryYear >= 2020 {
//          let monthString = Int(cardInfo.expiryMonth) < 10 ? "0\(cardInfo.expiryMonth)" : "\(cardInfo.expiryMonth)"
//          if let textfield = cardIOdelegate.textFieldForScannedData(type: .expirationDate) {
//            let yy = "\(cardInfo.expiryYear)".suffix(2)
//            textfield.setText("\(monthString)\(yy)")
//          }
//          if let textfield = cardIOdelegate.textFieldForScannedData(type: .expirationDateLong) {
//            textfield.setText("\(monthString)\(cardInfo.expiryYear)")
//          }
//        }
//        if 1...12 ~= Int(cardInfo.expiryMonth), let textfield = cardIOdelegate.textFieldForScannedData(type: .expirationMonth) {
//            let monthString = Int(cardInfo.expiryMonth) < 10 ? "0\(cardInfo.expiryMonth)" : "\(cardInfo.expiryMonth)"
//            textfield.setText(monthString)
//        }
//      if cardInfo.expiryYear >= 2020 {
//          if let textfield = cardIOdelegate.textFieldForScannedData(type: .expirationYear) {
//            let yy = String("\(cardInfo.expiryYear)".suffix(2))
//            textfield.setText(yy)
//          }
//          if let textfield = cardIOdelegate.textFieldForScannedData(type: .expirationYearLong) {
//            let yy = String("\(cardInfo.expiryYear)")
//            textfield.setText(yy)
//          }
//        }
//        if let cvc = cardInfo.cvv, !cvc.isEmpty, let textfield = cardIOdelegate.textFieldForScannedData(type: .cvc) {
//            textfield.setText(cvc)
//        }
//        cardIOdelegate.userDidFinishScan?()
//    }
}


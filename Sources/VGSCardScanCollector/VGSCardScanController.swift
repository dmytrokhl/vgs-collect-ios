//
//  VGSCardScanController.swift
//  VGSCardScanCollector
//
//  Created by Dima on 18.08.2020.
//  Copyright © 2020 VGS. All rights reserved.
//

import Foundation
import VGSCollectSDK

/// Controller responsible for managing CardScan scanner
public class VGSCardScanController {
    
    // MARK: - Attributes
    
    internal var scanHandler: VGSScanHandlerProtocol?
    
    /// `VGSCardIOScanControllerDelegate` - handle user interaction with `Card.io` scanner
    public var delegate: VGSCardScanControllerDelegate?
    
    
    // MARK: - Initialization
    /// Initialization
    ///
    /// - Parameters:
    ///   - delegate: `VGSCardIOScanControllerDelegate`. Default is `nil`.
    public required init(_ delegate: VGSCardScanControllerDelegate? = nil) {
          self.scanHandler = VGSCardScanHandler()
          self.delegate = delegate
    }
    
    // MARK: - Methods
    
    /// Present `Card.io` scanner.
    /// - Parameters:
    ///   - viewController: `UIViewController` that will present card scanner.
    ///   - animated: pass `true` to animate the presentation; otherwise, pass `false`.
    ///   - completion: the block to execute after the presentation finishes.
    public func presentCardScanner(on viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        scanHandler?.presentScanVC(on: viewController, animated: animated, completion: completion)
    }
    
    /// Dismiss `Card.io` scanner.
    ///
    /// - Parameters:
    ///   - animated: pass `true` to animate the dismiss of presented viewcontroller; otherwise, pass `false`.
    ///   - completion: the block to execute after the dismiss finishes.
    public func dismissCardScanner(animated: Bool, completion: (() -> Void)?) {
        scanHandler?.dismissScanVC(animated: animated, completion: completion)
    }
}


/// Supported scan data fields by Card.io
@objc
public enum CradScanDataType: Int {
    
    /// Credit Card Number. 16 digits string.
    case cardNumber
    
    /// Credit Card Expiration Date. String in format "01/21".
    case expirationDate
    
    /// Credit Card Expiration Month. String in format "01".
    case expirationMonth
    
    /// Credit Card Expiration Year. String in format "21".
    case expirationYear
    
    /// Credit Card CVC code. 3-4 digits string in format "123".
    case cvc
  
    /// Credit Card Expiration Date. String in format "01/2021".
    case expirationDateLong
  
    /// Credit Card Expiration Year. String in format "2021".
    case expirationYearLong
}

/// Delegates produced by `VGSCardIOScanController` instance.
@objc
public protocol VGSCardScanControllerDelegate {
    
    // MARK: - Handle user ineraction with `Card.io`
    
    /// On user confirm scanned data by selecting Done button on `Card.io` screen.
    @objc optional func userDidFinishScan()
    
    /// On user press Cancel buttonn on `Card.io` screen.
    @objc optional func userDidCancelScan()
    
    // MARK: - Manage scanned data
    
    /// Asks `VGSTextField` where scanned data with `VGSConfiguration.FieldType` need to be set. Called after user select Done button, just before userDidFinishScan() delegate.
    @objc func textFieldForScannedData(type: CradScanDataType) -> VGSTextField?
}


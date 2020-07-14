//
//  VGSCardScanController.swift
//  VGSCollectSDK
//
//  Created by Dima on 14.07.2020.
//  Copyright © 2020 VGS. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation.AVCaptureDevice

internal protocol VGSCardScanHandlerProtocol {
    var delegate: VGSCardScanControllerDelegate? { get set }
    
    func presentScanVC(on viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismissScanVC(animated: Bool, completion: (() -> Void)?)
}

/// Controller responsible for managing Card.io scanner
public class VGSCardScanController {
    
    // MARK: - Attributes
    
    internal var scanHandler: VGSCardScanHandlerProtocol?
    
    /// `VGSCardIOScanControllerDelegate` - handle user interaction with `Card.io` scanner
    public var delegate: VGSCardScanControllerDelegate? {
        set {
          scanHandler?.delegate = newValue
        }
        get {
          return scanHandler?.delegate
        }
    }
    
    /// Defines preferred `AVCaptureDevice.Position`. Deault is `AVCaptureDevice.Position.unspecified`
  internal var preferredCameraPosition: AVCaptureDevice.Position? = .unspecified
    
    // MARK: - Initialization
    /// Initialization
    ///
    /// - Parameters:
    ///   - delegate: `VGSCardIOScanControllerDelegate`. Default is `nil`.
    public required init(_ delegate: VGSCardScanControllerDelegate? = nil) {
        #if canImport(CardScan)
            self.scanHandler = VGSCardScanHandler()
            self.delegate = delegate
        #else
            print("Can't import CardIO. Please check that CardIO submodule is installed")
            return
        #endif
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

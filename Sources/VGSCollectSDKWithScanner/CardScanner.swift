//
//  CardScanner.swift
//  VGSCollectSDKWithScanner
//
//  Created by Dima on 17.08.2020.
//  Copyright © 2020 VGS. All rights reserved.
//

import Foundation
import UIKit
#if canImport(CardScan)
import CardScan
#endif
public class CardScanner {
  
  public init() {}
  
  internal var scanner: ScanViewController?
  
  public func presentScanner(form: UIViewController, delegate: UIViewController?) {
    showScanView(from: form)
  }
  
  func showScanView(from: UIViewController) {
    #if canImport(CardScan)
    guard let vc = ScanViewController.createViewController(withDelegate: nil) else {
        print("This device is incompatible with CardScan")
        return
    }
    self.scanner = vc
    from.present(vc, animated: true)
    #endif
  }
}


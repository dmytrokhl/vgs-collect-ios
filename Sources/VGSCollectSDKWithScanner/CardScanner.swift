//
//  CardScanner.swift
//  VGSCollectSDKWithScanner
//
//  Created by Dima on 17.08.2020.
//  Copyright © 2020 VGS. All rights reserved.
//

import Foundation
import UIKit
import CardScan

public class CardScanner {
  
  public init() {}
  
  internal var scanner: ScanViewController?
  
  public func presentScanner(form: UIViewController, delegate: ScanDelegate?) {
    guard let vc = ScanViewController.createViewController(withDelegate: delegate) else {
        print("This device is incompatible with CardScan")
        return
    }
    self.scanner = vc
    form.present(vc, animated: true)
  }
}

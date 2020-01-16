//
//  VGSScanProviderFactory.swift
//  VGSFramework
//
//  Created by Dima on 06.01.2020.
//  Copyright © 2020 VGS. All rights reserved.
//

import Foundation
import UIKit
#if canImport(CardIO)
import CardIO
#endif

#if canImport(CardCan)
import CardScan
#endif

internal class VGSScanProviderFactory {
    
    static func getScanProviderInstance(_ provider: ScanProvider) -> VGSScanProviderProtocol? {
        switch  provider {
        case .cardIO:
            return getCardIOProxy()
        }
    }
    
    private static func getCardScanProxy() -> VGSScanProviderProtocol? {
        #if canImport(CardScan)
            return VGSCardScanProxy()
        #else
            return nil
        #endif
    }
    
    private static func getCardIOProxy() -> VGSScanProviderProtocol? {
        #if canImport(CardIO)
            return VGSCardIOProxy()
        #else
            return nil
        #endif
    }
}

//
//  VGSCardScannerHandler.h
//  VGSCollectSDK
//
//  Created by Dima on 14.08.2020.
//  Copyright © 2020 VGS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VGSCardScannerHandler : NSObject
  
+ (BOOL)additionalModuleAvailable;
- (instancetype)init;

@end
NS_ASSUME_NONNULL_END

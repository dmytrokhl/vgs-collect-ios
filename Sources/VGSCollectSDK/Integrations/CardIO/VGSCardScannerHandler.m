//
//  VGSCardScannerHandler.m
//  VGSCollectSDK
//
//  Created by Dima on 14.08.2020.
//  Copyright © 2020 VGS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VGSCardScannerHandler.h"
@import CardIO;

@interface VGSCardScannerHandler()
@property (strong, nonatomic) CardIOPaymentViewController *vc;
@end


@implementation VGSCardScannerHandler: NSObject

+ (BOOL)additionalModuleAvailable {
    if ([CardIOPaymentViewController class]) {
        return YES;
    } else {
        return NO;
    }
}

- (instancetype)init {
    self = [super init];
    if (self && [VGSCardScannerHandler additionalModuleAvailable]) {
        _vc = [[CardIOPaymentViewController alloc] init];
    }
    return self;
}
@end



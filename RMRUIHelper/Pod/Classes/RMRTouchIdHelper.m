//
//  RMRTouchIdHelper.m
//  RMRUIHelper
//
//  Created by Roman Churkin on 29/01/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

#import "RMRTouchIdHelper.h"

@import LocalAuthentication.LAContext;


@implementation RMRTouchIdHelper

- (BOOL)appCanUseTouchId:(NSError * __autoreleasing *)error
{
    return [[LAContext new] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                                        error:error];
}

- (void)presentTouchIdAlertReason:(NSString *)reason
                           reply:(RMR_TouchIdReplyBlock)reply
{
    LAContext *myContext = [[LAContext alloc] init];
    myContext.localizedFallbackTitle = self.localizedFallbackTitle;

    NSError *touchIdError = nil;
    if (![self appCanUseTouchId:&touchIdError])  reply(NO, touchIdError);
    else {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:reason
                  reply:^(BOOL success, NSError *error) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          reply(success, error);
                      });
                  }];
    }
}

@end

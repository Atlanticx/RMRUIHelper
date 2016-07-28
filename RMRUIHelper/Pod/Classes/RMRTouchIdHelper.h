//
//  RMRTouchIdHelper.h
//  RMRUIHelper
//
//  Created by Roman Churkin on 29/01/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - Type def

typedef void(^RMR_TouchIdReplyBlock)(BOOL success, NSError *error);


@interface RMRTouchIdHelper : NSObject

/**
 @"" если надо скрыть вторую кнопку
 */
@property (nonatomic, copy) NSString *localizedFallbackTitle;

- (BOOL)appCanUseTouchId:(NSError * __autoreleasing *)error;

- (void)presentTouchIdAlertReason:(NSString *)reason
                            reply:(RMR_TouchIdReplyBlock)reply;
@end

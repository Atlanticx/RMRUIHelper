//
//  RMRAlertView.h
//  RMRUIHelper
//
//  Created by Roman Churkin on 28/01/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

@import UIKit;

#import "RMRModalView.h"

@class RMRAlertView;


#pragma mark - Constants

extern NSInteger const RMRAlertViewPrimaryButtonIndexDefault;


#pragma mark - Type def

typedef void(^RMRAlertViewCompletionHandler)(RMRAlertView *alertView, NSInteger buttonIndex);


@interface RMRAlertView : UIView <RMRModalView>

#pragma mark - Properties

@property (nonatomic, copy) RMRAlertViewCompletionHandler handler;
@property (nonatomic, assign, readonly) NSInteger primaryButtonIndex;


#pragma mark - Methods

+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
                              icon:(UIImage *)iconImage
                      buttonTitles:(NSArray *)buttonTitles
                primaryButtonIndex:(NSUInteger)primaryButtonIndex;

- (NSString *)buttonTitleAtIndex:(NSUInteger)buttonIndex;

- (void)showWithHandler:(RMRAlertViewCompletionHandler)handler;

- (void)show;

- (NSInteger)numberOfButtons;

- (BOOL)isVisible;

@end

//
//  RMRActionSheet.h
//  RMRUIHelper
//
//  Created by Roman Churkin on 28/01/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

@import UIKit;

#import "RMRModalView.h"
@class RMRActionSheet;


#pragma mark - Type def

typedef void(^RMRActionSheetCompletionHandler)(RMRActionSheet *actionSheet, NSInteger buttonIndex);


@interface RMRActionSheet : UIView <RMRModalView>

#pragma mark - Properties

@property (nonatomic, copy) RMRActionSheetCompletionHandler handler;


#pragma mark - Methods

+ (instancetype)actionSheetWithTitle:(NSString *)title
                   cancelButtonTitle:(NSString *)cancelTitle
                   otherButtonTitles:(NSArray *)buttonTitles;

- (NSString *)buttonTitleAtIndex:(NSUInteger)buttonIndex;

- (void)showWithHandler:(RMRActionSheetCompletionHandler)handler;

- (void)show;

- (NSInteger)numberOfButtons;

- (BOOL)isVisible;

- (NSInteger)cancelButtonIndex;

@end

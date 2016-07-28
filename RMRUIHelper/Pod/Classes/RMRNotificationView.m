//
//  RMRNotificationView.m
//  RMRUIHelper
//
//  Created by Roman Churkin on 16/02/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

#import "RMRNotificationView.h"

#import "RMRNotificationsController.h"
#import "NSString+RMRHelper.h"


@implementation RMRNotificationView

- (void)show
{
    [[RMRNotificationsController sharedController] presentView:self];
}

- (void)dismissCompletion:(void(^)())completion
{
    [[RMRNotificationsController sharedController] dismissView:self completion:completion];
}


#pragma mark — Private helper

- (void)abstractMethodException
{
    NSString *reason =
            [NSString RMR_exceptionReasonConstructor:[self class]
                                             message:_cmd
                                                body:@"Не реализован абстрактный метод"];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:reason
                                 userInfo:nil];
}


#pragma mark — RMRModalView

- (void)prepareForAnimation { [self abstractMethodException]; }

- (void)animationAppear { [self abstractMethodException]; }

- (void)animationHide { [self abstractMethodException]; }

- (void)configureLayoutForContainer:(UIView *)container { [self abstractMethodException]; }

@end

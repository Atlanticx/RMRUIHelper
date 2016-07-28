//
//  RMRNotificationsController.h
//  RMRUIHelper
//
//  Created by Roman Churkin on 16/02/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RMRModalView.h"


@interface RMRNotificationsController : NSObject

+ (instancetype)sharedController;

- (void)presentView:(UIView<RMRModalView> *)modalView;

- (void)dismissView:(UIView *)modalView completion:(void(^)())completion;

- (UIView *)viewOnScreen;

@end

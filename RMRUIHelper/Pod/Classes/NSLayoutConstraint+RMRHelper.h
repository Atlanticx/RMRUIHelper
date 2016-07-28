//
//  NSLayoutConstraint+RMRHelper.h
//  RMRUIHelper
//
//  Created by Roman Churkin on 28/01/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSLayoutConstraint (RMRHelper)

/**
 Метод проставляет заданный constant всем constraint в массиве
 */
+ (void)RMR_updateConstraints:(NSArray *)constraints withConstant:(CGFloat)constant;

/**
 Метод возвращает сумму значений constant*multiplier для всех constraint в массиве
 */
+ (CGFloat)RMR_constraintsConstantSum:(NSArray *)constraints;

@end

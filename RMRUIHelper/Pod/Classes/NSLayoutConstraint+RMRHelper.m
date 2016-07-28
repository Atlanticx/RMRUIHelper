//
//  NSLayoutConstraint+RMRHelper.m
//  RMRUIHelper
//
//  Created by Roman Churkin on 28/01/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

#import "NSLayoutConstraint+RMRHelper.h"


@implementation NSLayoutConstraint (RMRHelper)

+ (void)RMR_updateConstraints:(NSArray *)constraints withConstant:(CGFloat)constant
{
    for (NSLayoutConstraint *constraint in constraints) constraint.constant = constant;
}

+ (CGFloat)RMR_constraintsConstantSum:(NSArray *)constraints
{
    CGFloat sum = 0.f;

    for (NSLayoutConstraint *each in constraints) {
        sum += each.constant * each.multiplier;
    }

    return sum;
}

@end

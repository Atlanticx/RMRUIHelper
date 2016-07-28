//
//  RMRPassthroughWindow.m
//  RMRUIHelper
//
//  Created by Roman Churkin on 16/02/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

#import "RMRPassthroughWindow.h"


@implementation RMRPassthroughWindow

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) return nil;
    else return hitView;
}

@end

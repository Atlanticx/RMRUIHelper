//
//  RMRGradientLayer.m
//  AlfaStrah
//
//  Created by Roman Churkin on 17/04/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

#import "RMRGradientLayer.h"


@implementation RMRGradientLayer

- (void)updateColorsStart:(UIColor *)startColor stopColor:(UIColor *)stopColor
{
    NSArray *colors = @[(id)startColor.CGColor, (id)stopColor.CGColor];

    NSArray *locations = @[@0.f, @1.f];

    self.colors    = colors;
    self.locations = locations;
}

@end

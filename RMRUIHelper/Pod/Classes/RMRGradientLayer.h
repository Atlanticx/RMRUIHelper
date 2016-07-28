//
//  RMRGradientLayer.h
//  AlfaStrah
//
//  Created by Roman Churkin on 17/04/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

@import UIKit;
@import QuartzCore.CAGradientLayer;


@interface RMRGradientLayer : CAGradientLayer

- (void)updateColorsStart:(UIColor *)startColor stopColor:(UIColor *)stopColor;

@end

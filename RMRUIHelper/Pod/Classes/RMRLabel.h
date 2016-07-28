//
//  RMRLabel.h
//  RMRUIHelper
//
//  Created by Roman Churkin on 27/01/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RMRLabel : UILabel

- (instancetype)initWithFrame:(CGRect)frame NS_REQUIRES_SUPER;

- (void)awakeFromNib NS_REQUIRES_SUPER;

/**
 Наследники могут переопределить этот метод для установки шрифта
 после инициализации объекта из nib
 */
- (void)RMR_prepareAppearance;

@end

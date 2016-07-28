//
//  RMRLabel.m
//  RMRUIHelper
//
//  Created by Roman Churkin on 27/01/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

#import "RMRLabel.h"


@implementation RMRLabel

- (instancetype)initWithFrame:(CGRect)frame NS_REQUIRES_SUPER
{
    self = [super initWithFrame:frame];

    if (self) [self RMR_prepareAppearance];

    return self;
}

- (void)awakeFromNib NS_REQUIRES_SUPER { [self RMR_prepareAppearance]; }

- (void)RMR_prepareAppearance { /* Реализация по умолчанию ничего не делает */ }

@end

//
//  RMRBarsHelper.m
//  RMRUIHelper
//
//  Created by Roman Churkin on 27/01/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

#import "RMRBarsHelper.h"



@implementation UINavigationBar (RMRHelpers)

- (void)RMR_changeBarTranslucency:(NSNumber *)translucent UI_APPEARANCE_SELECTOR
{
    self.translucent = [translucent boolValue];
}

@end


@implementation UITabBar (RMRHelpers)

- (void)RMR_changeBarTranslucency:(NSNumber *)translucent UI_APPEARANCE_SELECTOR
{
    self.translucent = [translucent boolValue];
}

@end


@implementation UISearchBar (RMRHelpers)

- (void)RMR_changeBarTranslucency:(NSNumber *)translucent UI_APPEARANCE_SELECTOR
{
    self.translucent = [translucent boolValue];
}

@end


@implementation UIToolbar (RMRHelpers)

- (void)RMR_changeBarTranslucency:(NSNumber *)translucent UI_APPEARANCE_SELECTOR
{
    self.translucent = [translucent boolValue];
}

@end

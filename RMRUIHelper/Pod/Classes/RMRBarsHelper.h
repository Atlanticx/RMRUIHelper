//
//  RMRBarsHelper.h
//  RMRUIHelper
//
//  Created by Roman Churkin on 27/01/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

@import UIKit.UINavigationBar;
@import UIKit.UITabBar;
@import UIKit.UISearchBar;
@import UIKit.UIToolbar;


@interface UINavigationBar (RMRHelpers)
- (void)RMR_changeBarTranslucency:(NSNumber *)translucent UI_APPEARANCE_SELECTOR;
@end


@interface UITabBar (RMRHelpers)
- (void)RMR_changeBarTranslucency:(NSNumber *)translucent UI_APPEARANCE_SELECTOR;
@end


@interface UISearchBar (RMRHelpers)
- (void)RMR_changeBarTranslucency:(NSNumber *)translucent UI_APPEARANCE_SELECTOR;
@end


@interface UIToolbar (RMRHelpers)
- (void)RMR_changeBarTranslucency:(NSNumber *)translucent UI_APPEARANCE_SELECTOR;
@end

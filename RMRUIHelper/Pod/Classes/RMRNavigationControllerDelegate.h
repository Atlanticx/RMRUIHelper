//
//  RMRNavigationControllerDelegate.h
//  RMRUIHelper
//
//  Created by Roman Churkin on 28/01/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

@import Foundation;
@import UIKit.UINavigationController;


@interface RMRNavigationControllerDelegate : NSObject <UINavigationControllerDelegate>

/**
 Метод утсанавливает в качестве кнопки назад bar button с пустым title
 */
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated;

@end

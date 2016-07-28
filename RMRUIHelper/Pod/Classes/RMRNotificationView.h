//
//  RMRNotificationView.h
//  RMRUIHelper
//
//  Created by Roman Churkin on 16/02/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RMRModalView.h"

/**
 Базовый класс для Notification views
 
  Методы протокола <tt>RMRModalView</tt> должны реализовать наследники
 */
@interface RMRNotificationView : UIView <RMRModalView>

/**
 Метод запускает механизм отображения notification view на экране
 */
- (void)show;

/**
 Метод запускает механизм скрытия notification view с экрана
 */
- (void)dismissCompletion:(void(^)())completion;

@end

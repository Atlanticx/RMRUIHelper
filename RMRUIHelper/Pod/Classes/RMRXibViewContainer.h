//
//  RMRXibViewContainer.h
//  AlfaStrah
//
//  Created by Roman Churkin on 17/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

@import UIKit;

IB_DESIGNABLE


@interface RMRXibViewContainer : UIView

#pragma mark - Свойства

@property (nonatomic, readonly, weak) UIView *subView;


#pragma mark - Interface builder

@property (nonatomic, strong) IBInspectable NSString *viewClass;
@property (nonatomic, strong) IBInspectable NSString *top;
@property (nonatomic, strong) IBInspectable NSString *left;
@property (nonatomic, strong) IBInspectable NSString *bottom;
@property (nonatomic, strong) IBInspectable NSString *right;

@end

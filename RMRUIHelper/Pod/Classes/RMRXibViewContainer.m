//
//  RMRXibViewContainer.m
//  AlfaStrah
//
//  Created by Roman Churkin on 17/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

#import "RMRXibViewContainer.h"


@interface RMRXibViewContainer ()

#pragma mark - Свойства

@property (nonatomic, weak) UIView *subView;

@end


@implementation RMRXibViewContainer

- (void)initialize
{
    if (!self.viewClass) return;

    UIView *subView = [self loadViewFromNib:NSClassFromString(self.viewClass)];
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:subView];

    self.subView = subView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self initialize];

    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self initialize];
}

- (void)updateConstraints
{
    [self addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(left)-[subview]-(right)-|"
                                                options:0
                                                metrics:@{ @"left" : self.left?:@0, @"right" : self.right?:@0 }
                                                  views:@{ @"subview" : self.subView }]];
    [self addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(top)-[subview]-(bottom)-|"
                                                options:0
                                                metrics:@{ @"top" : self.top?:@0, @"bottom" : self.bottom?:@0 }
                                                  views:@{ @"subview" : self.subView }]];

    [super updateConstraints];
}

- (void)prepareForInterfaceBuilder
{
    [self initialize];
    [self layoutIfNeeded];
}


#pragma mark - Приватные методы

- (instancetype)loadViewFromNib:(Class)viewClass;
{
    NSString *className = NSStringFromClass(viewClass);

    NSBundle *bundle = [NSBundle bundleForClass:viewClass];

    if (![bundle pathForResource:className ofType:@"nib"]) return nil;

    NSArray *nibContents = [bundle loadNibNamed:className owner:nil options:nil];

    id view = nil;

    for (id obj in nibContents) {
        if ([obj isKindOfClass:viewClass]) {
            view = obj;
            break;
        }
    }

    return view;
}

@end

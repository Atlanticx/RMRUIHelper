//
//  RMRAlertView.m
//  RMRUIHelper
//
//  Created by Roman Churkin on 28/01/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

#import "RMRAlertView.h"

// Helpers
#import "RMRModalViewsController.h"
#import "UIView+RMRHelper.h"
#import "NSString+RMRHelper.h"


#pragma mark - Constants

static NSInteger const kRMRAlertViewPrimaryButtonIndexDefault = NSNotFound;

static NSString * const kRMRExceptionReasonAlertViewButtonTitleIndex =
    @"buttonIndex выходит за пределы массива кнопок BKAlertView";

static NSString * const kRMRExceptionReasonAlertViewButtonsNil =
    @"RMRAlertView не может быть инициализирован без кнопок."
    @"Укажите массив для параметра buttonTitles как минимум с одноим объектом NSString.";

static NSString * const kRMRExceptionReasonAlertViewButtonsCountZero =
    @"RMRAlertView не может быть инициализирован с пустым массивом"
    @"в качестве заголовков для кнопок."
    @"Укажите массив для параметра buttonTitles как минимум с одноим объектом NSString.";

static NSString * const kRMRExceptionReasonAlertViewPrimaryButtonIndex =
    @"primaryButtonIndex выходит за пределы переданного массива заголовков кнопок RMRAlertView";

static NSString * const kRMRExceptionReasonAlertViewButtonsTitleStrings =
    @"Массив заголовков для кнопок RMRAlertView должен состоять из экземпляров класса NSString";


@interface RMRAlertView ()

#pragma mark - Properties

@property (nonatomic, assign) NSInteger primaryButtonIndex;


#pragma mark - View properties

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *messageLabel;

@property (nonatomic, copy) NSArray *actionButtons;


#pragma mark - Outlets

@property (nonatomic, weak) IBOutlet UIView *iconImageContainer;
@property (nonatomic, weak) IBOutlet UIView *titleLabelContainer;
@property (nonatomic, weak) IBOutlet UIView *messageLabelContainer;
@property (nonatomic, weak) IBOutlet UIView *buttonsContainer;

@end


@implementation RMRAlertView

- (void)awakeFromNib
{
    self.primaryButtonIndex = kRMRAlertViewPrimaryButtonIndexDefault;
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.9f];
    self.layer.cornerRadius = 4.f;
    self.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth  = .5f;
}


#pragma mark - Public

+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
                              icon:(UIImage *)iconImage
                      buttonTitles:(NSArray *)buttonTitles
                primaryButtonIndex:(NSUInteger)primaryButtonIndex
{
    RMRAlertView *alertView = [self RMR_loadFromNib];
    
    [alertView configureIconImageViewWithImage:iconImage];
    [alertView configureTitleLabelWithText:title];
    [alertView configureMessageLabelWithText:message];
    
    [alertView configureButtonsWithTitles:buttonTitles
                       primaryButtonIndex:primaryButtonIndex];
    
    return alertView;
}

- (NSString *)buttonTitleAtIndex:(NSUInteger)buttonIndex
{
    if (buttonIndex >= [self.actionButtons count]) {
        NSString *reason =
                [NSString RMR_exceptionReasonConstructor:[self class]
                                                 message:_cmd
                                                    body:kRMRExceptionReasonAlertViewButtonTitleIndex];
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:reason
                                     userInfo:nil];
    }
    
    UIButton *button = self.actionButtons[buttonIndex];
    return [button titleForState:UIControlStateNormal];
}

- (void)showWithHandler:(RMRAlertViewCompletionHandler)handler
{
    self.handler = handler;
    
    [self show];
}

- (void)show
{
    [self addParallax];
    
    [[RMRModalViewsController sharedController] presentView:self];
}

- (NSInteger)numberOfButtons { return [self.actionButtons count]; }

- (BOOL)isVisible
{
    RMRModalViewsController *modalViewsController = [RMRModalViewsController sharedController];
    return [modalViewsController viewOnScreen] == self;
}


#pragma mark - UIView

- (void)tintColorDidChange
{
    [self.actionButtons makeObjectsPerformSelector:@selector(setTintColor:)
                                        withObject:self.tintColor];
    self.iconImageView.tintColor = self.tintColor;
}


#pragma mark - Private helpers

- (void)checkButtonTitles:(NSArray *)buttonTitles
{
    if (!buttonTitles) {
        NSString *reason =
                [NSString RMR_exceptionReasonConstructor:[self class]
                                                 message:_cmd
                                                    body:kRMRExceptionReasonAlertViewButtonsNil];
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:reason
                                     userInfo:nil];
    }
    
    
    if ([buttonTitles count] == 0) {
        NSString *reason =
                [NSString RMR_exceptionReasonConstructor:[self class]
                                                 message:_cmd
                                                    body:kRMRExceptionReasonAlertViewButtonsCountZero];
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:reason
                                     userInfo:nil];
    }
}

- (void)configureIconImageViewWithImage:(UIImage *)iconImage
{
    if (!iconImage) return;
    
    UIImageView *imageView =  [[UIImageView alloc] initWithImage:iconImage];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.tintColor = self.tintColor;
    self.iconImageView = imageView;
    [self.iconImageContainer addSubview:imageView];

    [self configureIconLayout];
}

- (void)configureTitleLabelWithText:(NSString *)title
{
    if (!title) return;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = [UIFont boldSystemFontOfSize:18.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.numberOfLines = 3;
    label.textColor = [UIColor blackColor];
    self.titleLabel = label;
    label.text = title;
    [self.titleLabelContainer addSubview:label];
    
    [self configureTitleLayout];
}

- (void)configureMessageLabelWithText:(NSString *)message
{
    if (!message) return;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = [UIFont systemFontOfSize:17.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    label.text = message;
    self.messageLabel = label;
    [self.messageLabelContainer addSubview:label];
    
    [self configureMessageLayout];
}

- (void)configureButtonsWithTitles:(NSArray *)buttonTitles
                primaryButtonIndex:(NSUInteger)primaryButtonIndex
{
    [self checkButtonTitles:buttonTitles];
    
    NSInteger buttonsTitleCount = [buttonTitles count];
    
    if (primaryButtonIndex == kRMRAlertViewPrimaryButtonIndexDefault)
    {
        if (buttonsTitleCount <= 2) primaryButtonIndex = 0;
        else primaryButtonIndex = buttonsTitleCount -1;
    }
    
    if (primaryButtonIndex >= buttonsTitleCount) {
        NSString *reason =
                [NSString RMR_exceptionReasonConstructor:[self class]
                                                 message:_cmd
                                                    body:kRMRExceptionReasonAlertViewPrimaryButtonIndex];
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:reason
                                     userInfo:nil];
    }
    
    self.primaryButtonIndex = primaryButtonIndex;
    
    NSMutableArray *actionButtons = [NSMutableArray arrayWithCapacity:buttonsTitleCount];
    
    UIView *container = self.buttonsContainer;
    
    void (^configureActionButtons)(id obj, NSUInteger idx, BOOL *stop) =
        ^(id obj, NSUInteger idx, BOOL *stop){
            if (![obj isKindOfClass:[NSString class]]) {
                NSString *reason =
                        [NSString RMR_exceptionReasonConstructor:[self class]
                                                         message:_cmd
                                                            body:kRMRExceptionReasonAlertViewButtonsTitleStrings];
                @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                               reason:reason
                                             userInfo:nil];
            }
            
            NSString *buttonTitle = (NSString *)obj;
            
            UIButton *button = nil;
            
            if (idx == primaryButtonIndex) {
                button = [UIButton buttonWithType:UIButtonTypeSystem];
                button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
            } else {
                button = [UIButton buttonWithType:UIButtonTypeSystem];
                button.titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
            }

            button.translatesAutoresizingMaskIntoConstraints = NO;

            [button setTitle:buttonTitle forState:UIControlStateNormal];
            [button addTarget:self
                       action:@selector(buttonAction:)
             forControlEvents:UIControlEventTouchUpInside];
            button.tintColor = self.tintColor;
            
            button.tag = idx;
            
            [container addSubview:button];
            
            [actionButtons addObject:button];
        };
    
    [[buttonTitles copy] enumerateObjectsUsingBlock:configureActionButtons];

    self.actionButtons = actionButtons;
    
    [self configureButtonsLayout];
}

- (UIView *)createSeparatorView
{
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectZero];
    separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    separatorView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2f];
    
    return separatorView;
}

- (void)addParallax
{
    UIInterpolatingMotionEffect *verticalMotionEffect =
        [[UIInterpolatingMotionEffect alloc]
            initWithKeyPath:@"center.y"
            type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-10);
    verticalMotionEffect.maximumRelativeValue = @(10);
    
    UIInterpolatingMotionEffect *horizontalMotionEffect =
        [[UIInterpolatingMotionEffect alloc]
            initWithKeyPath:@"center.x"
            type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-10);
    horizontalMotionEffect.maximumRelativeValue = @(10);
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    [self addMotionEffect:group];
}


#pragma mark - Layout

- (void)configureIconLayout
{
    UIView *container = self.iconImageContainer;
    UIImageView *imageView = self.iconImageView;

    [imageView setContentHuggingPriority:UILayoutPriorityRequired
                                 forAxis:UILayoutConstraintAxisVertical];

    [imageView setContentCompressionResistancePriority:UILayoutPriorityRequired
                                               forAxis:UILayoutConstraintAxisVertical];

    [container addConstraints:
       [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0@900)-[imageView]-(>=0@900)-|"
                                               options:0
                                               metrics:nil
                                                 views:NSDictionaryOfVariableBindings(imageView)]];
    [container addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20@1000)-[imageView]-(20@1000)-|"
                                                options:0
                                                metrics:nil
                                                  views:NSDictionaryOfVariableBindings(imageView)]];

    [container addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:container
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0f]];
}

- (void)configureTitleLayout
{
    UIView *container = self.titleLabelContainer;
    UILabel *titleLabel = self.titleLabel;

    [titleLabel setContentHuggingPriority:800.f
                                  forAxis:UILayoutConstraintAxisVertical];
    [titleLabel setContentHuggingPriority:100.f
                                  forAxis:UILayoutConstraintAxisHorizontal];

    [titleLabel setContentCompressionResistancePriority:810.f
                                                forAxis:UILayoutConstraintAxisVertical];
    [titleLabel setContentCompressionResistancePriority:100.f
                                                forAxis:UILayoutConstraintAxisHorizontal];

    [container addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titleLabel]|"
                                                options:0
                                                metrics:nil
                                                  views:NSDictionaryOfVariableBindings(titleLabel)]];
    [container addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]-(13)-|"
                                                options:0
                                                metrics:nil
                                                  views:NSDictionaryOfVariableBindings(titleLabel)]];
}

- (void)configureMessageLayout
{
    UIView *container = self.messageLabelContainer;
    UILabel *messageLabel = self.messageLabel;

    [messageLabel setContentHuggingPriority:700.f
                                    forAxis:UILayoutConstraintAxisVertical];
    [messageLabel setContentHuggingPriority:100.f
                                    forAxis:UILayoutConstraintAxisHorizontal];

    [messageLabel setContentCompressionResistancePriority:710.f
                                                  forAxis:UILayoutConstraintAxisVertical];
    [messageLabel setContentCompressionResistancePriority:100.f
                                                  forAxis:UILayoutConstraintAxisHorizontal];


    [container addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[messageLabel]|"
                                                options:0
                                                metrics:nil
                                                  views:NSDictionaryOfVariableBindings(messageLabel)]];
    [container addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[messageLabel]-(16)-|"
                                                options:0
                                                metrics:nil
                                                  views:NSDictionaryOfVariableBindings(messageLabel)]];
}

- (void)configureButtonsLayout
{
    if ([self.actionButtons count] == 1) [self configureOneButtonLayout];
    else if ([self.actionButtons count] <= 2) [self configureHorizontalButtonsLayout];
    else [self configureVerticalButtonsLayout];
}

- (void)configureOneButtonLayout
{
    UIView *container = self.buttonsContainer;

    UIView *verticalSeparator = [self createSeparatorView];

    [container addSubview:verticalSeparator];

    UIButton *button_1 = [self.actionButtons firstObject];

    [container addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[verticalSeparator]|"
                                                options:0
                                                metrics:nil
                                                  views:NSDictionaryOfVariableBindings(verticalSeparator)]];

    [container addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button_1]|"
                                                options:0
                                                metrics:nil
                                                  views:NSDictionaryOfVariableBindings(button_1)]];

    [verticalSeparator addConstraint:[NSLayoutConstraint constraintWithItem:verticalSeparator
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:0.5f]];

    [self configureVerticalLayoutForSeparator:verticalSeparator
                                       button:button_1
                                  inContainer:container];
}

- (void)configureVerticalLayoutForSeparator:(UIView *)separator
                                     button:(UIButton *)button
                                inContainer:(UIView *)container
{
    [container addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[separator][button]|"
                                                options:0
                                                metrics:nil
                                                  views:NSDictionaryOfVariableBindings(separator, button)]];
}

- (void)configureHorizontalButtonsLayout
{
    UIView *container = self.buttonsContainer;

    UIView *verticalSeparator = [self createSeparatorView];
    UIView *horizontalSeparator = [self createSeparatorView];

    [container addSubview:verticalSeparator];
    [container addSubview:horizontalSeparator];

    [container addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[verticalSeparator]|"
                                                options:0
                                                metrics:nil
                                                  views:NSDictionaryOfVariableBindings(verticalSeparator)]];

    [verticalSeparator addConstraint:[NSLayoutConstraint constraintWithItem:verticalSeparator
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:0.5f]];

    [horizontalSeparator addConstraint:[NSLayoutConstraint constraintWithItem:horizontalSeparator
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f
                                                                     constant:0.5f]];

    UIButton *button_1 = [self.actionButtons firstObject];
    UIButton *button_2 = [self.actionButtons lastObject];

    NSDictionary *horizontalBindingsDictionary =
    NSDictionaryOfVariableBindings(button_1, horizontalSeparator, button_2);

    NSString *horizontalFormat = @"H:|[button_1][horizontalSeparator][button_2(==button_1)]|";

    [container addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:horizontalFormat
                                             options:0
                                             metrics:nil
                                               views:horizontalBindingsDictionary]];

    [self configureVerticalLayoutForSeparator:verticalSeparator button:button_1 inContainer:container];
    [self configureVerticalLayoutForSeparator:verticalSeparator button:button_2 inContainer:container];

    [container addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[verticalSeparator][horizontalSeparator]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(verticalSeparator, horizontalSeparator)]];

    [button_1 setContentCompressionResistancePriority:UILayoutPriorityRequired
                                              forAxis:UILayoutConstraintAxisVertical];
    [button_2 setContentCompressionResistancePriority:UILayoutPriorityRequired
                                              forAxis:UILayoutConstraintAxisVertical];
}

- (void)configureVerticalButtonsLayout
{
    UIView *container = self.buttonsContainer;

    NSMutableString *formatString = [@"V:|" mutableCopy];
    NSMutableDictionary *bindingsDictionary = [NSMutableDictionary dictionary];

    void (^createConstraintsForButtons)(id obj, NSUInteger idx, BOOL *stop) =
            ^(id obj, NSUInteger idx, BOOL *stop) {
                UIView *verticalSeparatorView = [self createSeparatorView];
                [container addSubview:verticalSeparatorView];
                [container addConstraints:
                    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[verticalSeparatorView]|"
                                                            options:0
                                                            metrics:nil
                                                              views:NSDictionaryOfVariableBindings(verticalSeparatorView)]];

                NSString *verticalSeparatorKey =
                    [NSString stringWithFormat:@"separator_%lu", (unsigned long)idx];

                [bindingsDictionary setValue:verticalSeparatorView forKey:verticalSeparatorKey];


                UIButton *actionButton = (UIButton *)obj;

                [container addConstraints:
                   [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[actionButton]|"
                                                           options:0
                                                           metrics:nil
                                                             views:NSDictionaryOfVariableBindings(actionButton)]];

                NSString *actionButtonKey = [NSString stringWithFormat:@"button_%lu", (unsigned long)idx];

                [bindingsDictionary setValue:actionButton forKey:actionButtonKey];

                [formatString appendFormat:
                 @"[%@(0.5@1000)][%@]", verticalSeparatorKey, actionButtonKey];
            };

    [[self.actionButtons mutableCopy] enumerateObjectsUsingBlock:createConstraintsForButtons];

    [formatString appendString:@"|"];

    [container addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:formatString
                                             options:0
                                             metrics:nil
                                               views:bindingsDictionary]];
}


#pragma mark - Actions

- (void)buttonAction:(UIButton *)button
{
    typeof(self) __weak weakSelf = self;

    RMRModalViewsController *modalViewsController = [RMRModalViewsController sharedController];
    [modalViewsController dismissView:self
                           completion:^{
                               typeof(weakSelf) strongSelf = weakSelf;
                               if (strongSelf.handler) strongSelf.handler(strongSelf, button.tag);
                           }];
}


#pragma mark - BKModalView

- (void)prepareForAnimation
{
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(.8, .8);
}

- (void)animationAppear
{
    self.alpha = 1.f;
    self.transform = CGAffineTransformIdentity;
}

- (void)animationHide
{
    [self layoutIfNeeded];

    [self prepareForAnimation];
}

- (void)configureLayoutForContainer:(UIView *)container
{
    UIView *view = self;

    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=25@990)-[view(>=256@1000)]-(>=25@990)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(view)]];
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=8@1000)-[view]-(>=8@1000)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(view)]];
    [container addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:container
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [container addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:container
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0f
                                                           constant:0.0f]];
}

@end

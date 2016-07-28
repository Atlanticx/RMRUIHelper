//
//  RMRActionSheet.m
//  RMRUIHelper
//
//  Created by Roman Churkin on 28/01/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

#import "RMRActionSheet.h"

// Helpers
#import "UIView+RMRHelper.h"
#import "RMRModalViewsController.h"
#import "NSString+RMRHelper.h"


#pragma mark - Constants

static CGFloat const kBKActionSheetBottomPaddingDefault = 8.f;

static NSString * const kRMRExceptionReasonActionSheetButtonTitleIndex =
    @"buttonIndex выходит за пределы массива кнопок RMRActionSheet";

static NSString * const kRMRExceptionReasonActionSheetButtonsTitleStrings =
    @"Массив заголовков для кнопок RMRActionSheet должен состоять из экземпляров класса NSString";


@interface RMRActionSheet ()

#pragma mark - Properties

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSArray *actionButtons;


#pragma mark - Outlets

@property (nonatomic, weak) IBOutlet UIView *actionSheetContainer;
@property (nonatomic, weak) IBOutlet UIView *titleLabelContainer;
@property (nonatomic, weak) IBOutlet UIView *actionButtonsContainer;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIView *cancelButtonContainer;
@property (nonatomic, weak) IBOutlet UIButton *forceCloseButton;

@property (unsafe_unretained, nonatomic) IBOutlet
    NSLayoutConstraint *cancelButtonContainerBottomConstraint;

@end


@implementation RMRActionSheet

- (void)awakeFromNib
{
    UIColor *backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.9f];

    self.actionSheetContainer.backgroundColor =
        self.cancelButtonContainer.backgroundColor = backgroundColor;

    self.actionSheetContainer.layer.cornerRadius =
        self.cancelButtonContainer.layer.cornerRadius = 4.f;

    self.actionSheetContainer.layer.borderColor =
        self.cancelButtonContainer.layer.borderColor =
            [UIColor lightGrayColor].CGColor;

    self.actionSheetContainer.layer.borderWidth =
        self.cancelButtonContainer.layer.borderWidth = .5f;
}


#pragma mark - Public

+ (instancetype)actionSheetWithTitle:(NSString *)title
                   cancelButtonTitle:(NSString *)cancelTitle
                   otherButtonTitles:(NSArray *)buttonTitles
{
    RMRActionSheet *actionSheet = [RMRActionSheet RMR_loadFromNib];
    
    [actionSheet.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
    actionSheet.cancelButton.tag = [buttonTitles count];
    
    [actionSheet configureTitleLabelWithText:title];
    [actionSheet configureButtonsWithTitles:buttonTitles];
    
    [actionSheet layoutIfNeeded];
    
    return actionSheet;
}

- (NSString *)buttonTitleAtIndex:(NSUInteger)buttonIndex
{
    if (buttonIndex >= [self.actionButtons count]) {
        NSString *reason =
                [NSString RMR_exceptionReasonConstructor:[self class]
                                                 message:_cmd
                                                    body:kRMRExceptionReasonActionSheetButtonTitleIndex];
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:reason
                                     userInfo:nil];
    }
    
    UIButton *button = self.actionButtons[buttonIndex];
    return [button titleForState:UIControlStateNormal];
}

- (void)showWithHandler:(RMRActionSheetCompletionHandler)handler
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

- (NSInteger)cancelButtonIndex { return self.cancelButton.tag; }


#pragma mark - UIView

- (void)tintColorDidChange
{
    [self.actionButtons makeObjectsPerformSelector:@selector(setTintColor:)
                                        withObject:self.tintColor];

    self.cancelButton.tintColor = self.tintColor;
}


#pragma mark - BKModalView

- (void)prepareForAnimation
{
    CGFloat modifier =
        CGRectGetHeight(self.bounds) - CGRectGetMinY(self.actionSheetContainer.frame);
    
    self.cancelButtonContainerBottomConstraint.constant = -modifier;
    [self layoutIfNeeded];
    
    self.alpha = .75f;
}

- (void)animationAppear
{
    self.cancelButtonContainerBottomConstraint.constant = kBKActionSheetBottomPaddingDefault;
    [self layoutIfNeeded];

    self.alpha = 1.f;
}

- (void)animationHide { [self prepareForAnimation]; }


- (void)configureLayoutForContainer:(UIView *)container
{
    UIView *view = self;

    [container addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                options:0
                                                metrics:nil
                                                  views:NSDictionaryOfVariableBindings(view)]];
    [container addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=8@1000)-[view]|"
                                                options:0
                                                metrics:nil
                                                  views:NSDictionaryOfVariableBindings(view)]];

    [container addConstraint:[NSLayoutConstraint constraintWithItem:self.forceCloseButton
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:container
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:0.0f]];
}


#pragma mark - Private helpers

- (void)configureTitleLabelWithText:(NSString *)title
{
    if (!title) return;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = [UIFont boldSystemFontOfSize:18.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.numberOfLines = 5;
    label.textColor = [UIColor blackColor];
    label.text = title;
    self.titleLabel = label;
    [self.titleLabelContainer addSubview:label];
    
    [self configureTitleLayout];
}

- (void)configureButtonsWithTitles:(NSArray *)buttonTitles
{
    NSInteger buttonsTitleCount = [buttonTitles count];

    NSMutableArray *actionButtons = [NSMutableArray arrayWithCapacity:buttonsTitleCount];
    
    UIView *container = self.actionButtonsContainer;
    
    void (^configureActionButtons)(id obj, NSUInteger idx, BOOL *stop) =
        ^(id obj, NSUInteger idx, BOOL *stop){
            if (![obj isKindOfClass:[NSString class]]) {
                NSString *reason =
                        [NSString RMR_exceptionReasonConstructor:[self class]
                                                         message:_cmd
                                                            body:kRMRExceptionReasonActionSheetButtonsTitleStrings];
                @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                               reason:reason
                                             userInfo:nil];
            }
            
            NSString *buttonTitle = (NSString *)obj;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            
            [button setTitle:buttonTitle forState:UIControlStateNormal];
            [button addTarget:self
                       action:@selector(buttonAction:)
             forControlEvents:UIControlEventTouchUpInside];
            
            button.tag = idx;
            
            [container addSubview:button];
            
            [actionButtons addObject:button];
        };
    
    [[buttonTitles copy] enumerateObjectsUsingBlock:configureActionButtons];
    
    self.actionButtons = actionButtons;
    
    [self configureButtonsLayout];
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

- (UIView *)createSeparatorView
{
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectZero];
    separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    separatorView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2f];
    
    return separatorView;
}


#pragma mark - Layout helpers

- (void)configureTitleLayout
{
    UIView *container = self.titleLabelContainer;
    UILabel *titleLabel = self.titleLabel;
    
    [titleLabel setContentHuggingPriority:800.f
                                  forAxis:UILayoutConstraintAxisVertical];
    
    [titleLabel setContentCompressionResistancePriority:800.f
                                                forAxis:UILayoutConstraintAxisVertical];

    [container addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[titleLabel]-8-|"
                                                options:0
                                                metrics:nil
                                                  views:NSDictionaryOfVariableBindings(titleLabel)]];
    [container addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[titleLabel]-16-|"
                                                options:0
                                                metrics:nil
                                                  views:NSDictionaryOfVariableBindings(titleLabel)]];
}

- (void)configureButtonsLayout
{
    if ([self.actionButtons count] == 0) return;
    
    UIView *container = self.actionButtonsContainer;
    
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
            [verticalSeparatorView addConstraint:[NSLayoutConstraint constraintWithItem:verticalSeparatorView
                                                                              attribute:NSLayoutAttributeHeight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:nil
                                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                                             multiplier:1.0f
                                                                               constant:0.5f]];

            NSString *verticalSeparatorKey =
                [NSString stringWithFormat:@"separator_%lu", (unsigned long)idx];
            
            [bindingsDictionary setValue:verticalSeparatorView forKey:verticalSeparatorKey];

            UIButton *actionButton = (UIButton *)obj;

            [container addConstraints:
                [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[actionButton]|"
                                                        options:0
                                                        metrics:nil
                                                          views:NSDictionaryOfVariableBindings(actionButton)]];

            NSString *actionButtonKey =
                [NSString stringWithFormat:@"button_%lu", (unsigned long)idx];
            
            [bindingsDictionary setValue:actionButton forKey:actionButtonKey];
            
            [formatString appendFormat:@"[%@][%@]", verticalSeparatorKey, actionButtonKey];
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

- (IBAction)buttonAction:(UIButton *)button
{
    typeof(self) __weak weakSelf = self;
    
    RMRModalViewsController *modalViewsController = [RMRModalViewsController sharedController];
    [modalViewsController dismissView:self
                           completion:^{
                               typeof(weakSelf) strongSelf = weakSelf;
                               if (strongSelf.handler) strongSelf.handler(strongSelf, button.tag);
                           }];
}

- (IBAction)forceCloseScreen:(id)sender { [self buttonAction:self.cancelButton]; }

@end

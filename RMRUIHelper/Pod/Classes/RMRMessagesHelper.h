//
//  RMRMessagesHelper.h
//  RMRUIHelper
//
//  Created by Roman Churkin on 09/02/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RMRMessagesHelper;


#pragma mark — Type def

typedef NS_ENUM(NSInteger, RMRMessagesHelperType) {
    RMRMessagesHelperTypeMail,
    RMRMessagesHelperTypeMessage
};


@protocol RMRMessagesHelperPresenter

@required
- (void)messagesHelper:(RMRMessagesHelper *)messageHelper processError:(NSError *)error;

@optional
- (void)messagesHelper:(RMRMessagesHelper *)messageHelper notSupportedMessageType:(RMRMessagesHelperType)messageType;

@end


@interface RMRMessagesHelper : NSObject

@property (nonatomic, weak, readonly) UIViewController<RMRMessagesHelperPresenter> *presenter;

- (instancetype)initWithPresenter:(UIViewController<RMRMessagesHelperPresenter> *)presenter;

- (void)sendMailTo:(NSArray *)mailList withSubject:(NSString *)subject andMessage:(NSString *)message;
- (void)sendMessage:(NSString *)message to:(NSArray *)recipients;

@end

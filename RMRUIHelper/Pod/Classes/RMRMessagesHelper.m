//
//  RMRMessagesHelper.m
//  RMRUIHelper
//
//  Created by Roman Churkin on 09/02/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

#import "RMRMessagesHelper.h"

@import MessageUI.MFMailComposeViewController;
@import MessageUI.MFMessageComposeViewController;


@interface RMRMessagesHelper () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, weak) UIViewController<RMRMessagesHelperPresenter> *presenter;

@end


@implementation RMRMessagesHelper

- (instancetype)initWithPresenter:(UIViewController<RMRMessagesHelperPresenter> *)presenter
{
    self = [super init];

    if (!self) return nil;
    else {
        self.presenter = presenter;
        return self;
    }
}

- (void)sendMailTo:(NSArray *)mailList withSubject:(NSString *)subject andMessage:(NSString *)message
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposeViewController =
            [self mailComposeViewControllerForMailList:mailList
                                           withSubject:subject
                                            andMessage:message];
        
        [self.presenter presentViewController:mailComposeViewController
                                     animated:YES
                                   completion:nil];
    } else if ([self.presenter respondsToSelector:@selector(messagesHelper:notSupportedMessageType:)]) {
        [self.presenter messagesHelper:self
               notSupportedMessageType:RMRMessagesHelperTypeMail];
    } else {
        NSString *email =
            [NSString stringWithFormat:@"mailto:%@?subject=%@&body=%@",
                [mailList componentsJoinedByString:@","],
                subject, message];

        email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        NSURL *mailUrl = [NSURL URLWithString:email];

        [[UIApplication sharedApplication] openURL:mailUrl];
    }
}

- (void)sendMessage:(NSString *)message to:(NSArray *)recipients
{
    MFMessageComposeViewController *messageComposeViewController =
        [self messageComposeViewControllerForRecipients:recipients body:message];

    if (messageComposeViewController && [MFMessageComposeViewController canSendText]) {
        [self.presenter presentViewController:messageComposeViewController
                                     animated:YES
                                   completion:nil];
    } else if ([self.presenter respondsToSelector:@selector(messagesHelper:notSupportedMessageType:)]) {
        [self.presenter messagesHelper:self
               notSupportedMessageType:RMRMessagesHelperTypeMessage];
    } else NSLog(@"Следует использвать делегат для проверки возможности отправки сообщений");
}


#pragma mark — Private helpers

- (MFMailComposeViewController *)mailComposeViewControllerForMailList:(NSArray *)mailList
                                                          withSubject:(NSString *)subject
                                                           andMessage:(NSString *)message
{
    MFMailComposeViewController *mailComposeViewController =
        [[MFMailComposeViewController alloc] init];
    mailComposeViewController.mailComposeDelegate = self;

    [mailComposeViewController setSubject:subject];
    [mailComposeViewController setMessageBody:message isHTML:NO];

    [mailComposeViewController setToRecipients:mailList];

    return mailComposeViewController;
}

- (MFMessageComposeViewController *)messageComposeViewControllerForRecipients:(NSArray *)recipients
                                                                         body:(NSString *)body
{
    MFMessageComposeViewController *messageComposeViewController =
        [[MFMessageComposeViewController alloc] init];
    messageComposeViewController.messageComposeDelegate = self;

    messageComposeViewController.recipients = recipients;
    messageComposeViewController.body = body;

    return messageComposeViewController;
}


#pragma mark — MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultFailed) {
        [self.presenter messagesHelper:self processError:error];
    }

    [self.presenter dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark — MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result;
{
    [self.presenter dismissViewControllerAnimated:YES completion:nil];
}

@end

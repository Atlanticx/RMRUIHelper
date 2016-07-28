//
//  RMRAddressBookPhoneHelper.m
//  RMRUIHelper
//
//  Created by Roman Churkin on 28/01/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

#import "RMRAddressBookPhoneHelper.h"

@import AddressBookUI;


// Helper
#import "RMRNavigationControllerDelegate.h"


#pragma mark - Helper

void OB_CFRelease(CFTypeRef cf) { if (cf) CFRelease(cf); }


@interface RMRAddressBookPhoneHelper () <ABPeoplePickerNavigationControllerDelegate>

#pragma mark - Properties

@property (nonatomic, strong) UIViewController *currentViewController;

@end


@implementation RMRAddressBookPhoneHelper

+ (instancetype)addressbookPhoneHelperNumberChosen:(RMRPhoneNumberChosen)phoneNumberChosen
                                          canceled:(RMRPhoneHelperCanceled)canceled
{
    RMRAddressBookPhoneHelper *addressbookHelper = [RMRAddressBookPhoneHelper new];
    addressbookHelper.phoneNumberChosen = phoneNumberChosen;
    addressbookHelper.canceled = canceled;

    ABPeoplePickerNavigationController *picker =
        [[ABPeoplePickerNavigationController alloc] init];
    
    // MARK: iOS 8
    BOOL needPrepareForIos8 = [self iOS8ReadyPickerLogic];

    if (needPrepareForIos8) [self preparePickerForPhoneNumberPick:picker];

    picker.peoplePickerDelegate = addressbookHelper;
    picker.displayedProperties  = @[@(kABPersonPhoneProperty)];

    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    addressbookHelper.currentViewController = window.rootViewController;

    [addressbookHelper.currentViewController presentViewController:picker
                                                          animated:YES
                                                        completion:nil];
    
    return addressbookHelper;
}


#pragma mark - ABPersonViewControllerDelegate

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self.currentViewController dismissViewControllerAnimated:YES completion:^{
        if (self.canceled) self.canceled();
    }];
}


#pragma mark - ABPersonViewControllerDelegate iOS 7

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    if (property == kABPersonPhoneProperty) {
        [self extractAndSendPhoneNumberFromPerson:person
                                       identifier:identifier];
    }
    
    return NO;
}


#pragma mark - ABPersonViewControllerDelegate iOS 8

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker
                         didSelectPerson:(ABRecordRef)person
{
        [self extractAndSendPhoneNumberFromPerson:person
                                       identifier:kABMultiValueInvalidIdentifier];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker
                         didSelectPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    if (property == kABPersonPhoneProperty) {
        [self extractAndSendPhoneNumberFromPerson:person
                                       identifier:identifier];
    }
}


#pragma mark - Helper

+ (BOOL)iOS8ReadyPickerLogic
{
    return
        [ABPeoplePickerNavigationController instancesRespondToSelector:@selector(setPredicateForEnablingPerson:)]
        && [ABPeoplePickerNavigationController instancesRespondToSelector:@selector(setPredicateForSelectionOfPerson:)];

}

+ (void)preparePickerForPhoneNumberPick:(ABPeoplePickerNavigationController *)pickerNavigationController
{
    pickerNavigationController.predicateForEnablingPerson =
        [NSPredicate predicateWithFormat:@"%K.@count > 0", ABPersonPhoneNumbersProperty];

    pickerNavigationController.predicateForSelectionOfPerson =
        [NSPredicate predicateWithFormat:@"%K.@count = 1", ABPersonPhoneNumbersProperty];
}

- (void)extractAndSendPhoneNumberFromPerson:(ABRecordRef)person
                                 identifier:(ABMultiValueIdentifier)identifier
{
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    CFIndex index = 0;
    if (identifier != kABMultiValueInvalidIdentifier) {
        index = ABMultiValueGetIndexForIdentifier(phoneNumbers, identifier);
    }

    CFStringRef pNumber = ABMultiValueCopyValueAtIndex(phoneNumbers, index);
    
    NSString *phoneNumber = pNumber != NULL? (__bridge NSString *)pNumber : nil;
    phoneNumber = [phoneNumber copy];
    
    OB_CFRelease(phoneNumbers);
    OB_CFRelease(pNumber);
    
    [self.currentViewController dismissViewControllerAnimated:YES completion:^{
        if (self.phoneNumberChosen) self.phoneNumberChosen(phoneNumber);
    }];
}


#pragma mark - Helper

+ (void)getAddressBookPermission:(void(^)(BOOL granted))completion
{
    if ([self iOS8ReadyPickerLogic]) {
        if (completion) completion(YES);
    } else {
        ABAddressBookRequestAccessWithCompletion(NULL, ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion((BOOL)granted);
            });
        });   
    }
}

@end

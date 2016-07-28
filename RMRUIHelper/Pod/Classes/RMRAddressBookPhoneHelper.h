//
//  RMRAddressBookPhoneHelper.h
//  RMRUIHelper
//
//  Created by Roman Churkin on 28/01/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Блок, который будет вызван, когда пользователь выбран номер телефона
 из адресной книги.
 */
typedef void(^RMRPhoneNumberChosen)(NSString *phoneNumber);

/**
 Блок, который будет вызван в случае отмены выбора.
 */
typedef void(^RMRPhoneHelperCanceled)();


@interface RMRAddressBookPhoneHelper : NSObject

#pragma mark - Properties

@property (nonatomic, copy) RMRPhoneNumberChosen phoneNumberChosen;
@property (nonatomic, copy) RMRPhoneHelperCanceled canceled;

+ (instancetype)addressbookPhoneHelperNumberChosen:(RMRPhoneNumberChosen)phoneNumberChosen
                                          canceled:(RMRPhoneHelperCanceled)canceled;

/**
 Запросить у пользователя разрешение на доступ к адресной книге.
 
 @param completion Блок, воторый будет выполнен по завершению процедуры.
 */
+ (void)getAddressBookPermission:(void(^)(BOOL granted))completion NS_DEPRECATED_IOS(7_0, 8_0);

@end
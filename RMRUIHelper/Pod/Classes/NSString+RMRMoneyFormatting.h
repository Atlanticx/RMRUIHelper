//
//  NSString+RMRMoneyFormatting.h
//  RMRUIHelper
//
//  Created by Roman Churkin on 16/02/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol RMRMonetaryObject <NSObject>

- (NSNumber *)amount;
- (NSString *)currency;

@end


@interface NSString (RMRMoneyFormatting)

/**
 Метод для форматирования надписей, показывающих количество денег.

 Возвращает строку с деньгами, сформатированную в соответствии с текущей локалью и символом заданной валюты.

 @param amount - сумма;
 @param currency - валюта в ISO 4217: "RUR".
 */
+ (NSString *)RMR_formattedStringWithMonetaryObject:(id<RMRMonetaryObject>)money;

/**
 Метод для форматирования надписей, показывающих количество денег.

 Возвращает строку с деньгами с указанием копеек, сформатированную в соответствии с текущей локалью и символом заданной валюты.

 @param amount - сумма;
 @param currency - валюта в ISO 4217: "RUR".
 */
+ (NSString *)RMR_formattedStringWithCentsWithMonetaryObject:(id<RMRMonetaryObject>)money;

/**
 Получить символ валюты по коду.

 @param iso4217Currency - валюта в ISO 4217: "RUR".

 @return Возвращает символ валюты. К примеру, "$".
 */
+ (NSString *)RMR_currencyFromIso4217:(NSString *)iso4217Currency;

@end

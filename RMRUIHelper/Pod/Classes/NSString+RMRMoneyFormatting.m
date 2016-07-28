//
//  NSString+RMRMoneyFormatting.m
//  RMRUIHelper
//
//  Created by Roman Churkin on 16/02/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

#import "NSString+RMRMoneyFormatting.h"


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@implementation NSString (RMRMoneyFormatting)

+ (NSString *)RMR_formattedStringWithMonetaryObject:(id<RMRMonetaryObject>)money
{
    static NSNumberFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setMaximumFractionDigits:0];
        [formatter setMinimumFractionDigits:0];
        [formatter setLocale:[self RMR_userLocale]];
    });

    [formatter setCurrencySymbol:[self RMR_currencyFromIso4217:[money currency]]];

    return [formatter stringFromNumber:[money amount]];
}

+ (NSString *)RMR_formattedStringWithCentsWithMonetaryObject:(id<RMRMonetaryObject>)money
{
    static NSNumberFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setMaximumFractionDigits:2];
        [formatter setMinimumFractionDigits:2];
        [formatter setLocale:[self RMR_userLocale]];
    });

    [formatter setCurrencySymbol:[self RMR_currencyFromIso4217:[money currency]]];

    return [formatter stringFromNumber:[money amount]];
}

+ (NSString *)RMR_currencyFromIso4217:(NSString *)iso4217Currency
{
    if (!iso4217Currency) return @"";

    NSArray *currencyCodes = @[
                               @"RUR",
                               @"USD",
                               @"EUR"
                               ];

    switch ([currencyCodes indexOfObject:[iso4217Currency uppercaseStringWithLocale:[NSLocale currentLocale]]]) {
        case 0:
            return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") ? @"₽" : @"Руб.";

        case 1:
            return @"$";

        case 2:
            return @"€";

        default:
            return @"";
    }
}

+ (NSLocale *)RMR_userLocale
{
    return [NSLocale localeWithLocaleIdentifier:[[NSLocale preferredLanguages] firstObject]];
}

@end

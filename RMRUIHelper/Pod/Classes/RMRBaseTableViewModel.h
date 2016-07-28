//
//  RMRBaseTableViewModel.h
//  RMRUIHelper
//
//  Created by Roman Churkin on 06/02/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMRTableViewModel.h"

/**
 Асбтрактный класс, реализующий протокол RMRTableViewModel
 */
@interface RMRBaseTableViewModel : NSObject <RMRTableViewModel>

/**
 По умолчанию метод возвращает 0, это подразумевает, что постраничная загрузка отключена
 */
- (NSInteger)itemsRequestLimit;

@end

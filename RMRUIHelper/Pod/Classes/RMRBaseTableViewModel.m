//
//  RMRBaseTableViewModel.m
//  RMRUIHelper
//
//  Created by Roman Churkin on 06/02/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

#import "RMRBaseTableViewModel.h"

// Helper
#import "NSString+RMRHelper.h"


#pragma mark — Constants

static NSString * const kRMRBaseTableViewModelAbstractMethod =
    @"В наследнике не реализован асбтрактный метод";


@implementation RMRBaseTableViewModel

- (NSInteger)itemsRequestLimit { return 0; }

- (void)getItemsOffset:(NSInteger)offset
            completion:(RMRTableViewModelGetItemsSucces)completion
               failure:(RMRTableViewModelFailure)failure
{
    NSString *reason =
            [NSString RMR_exceptionReasonConstructor:[self class]
                                             message:_cmd
                                                body:kRMRBaseTableViewModelAbstractMethod];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:reason
                                 userInfo:nil];
}

- (void)removeItems:(NSArray *)itemsToRemove
         completion:(RMRTableViewModelRemoveItemsSucces)completion
            failure:(RMRTableViewModelFailure)failure
{
    NSString *reason =
            [NSString RMR_exceptionReasonConstructor:[self class]
                                             message:_cmd
                                                body:kRMRBaseTableViewModelAbstractMethod];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:reason
                                 userInfo:nil];
}


@end

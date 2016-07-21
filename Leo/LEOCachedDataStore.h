//
//  LEOCachedDataStore.h
//  Leo
//
//  Created by Adam Fanslau on 2/23/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOPromise.h"
#import "LEOSyncronousDataSource.h"
#import "LEOAsyncDataSource.h"

@class Practice, Family, Guardian, Patient, User;

NS_ASSUME_NONNULL_BEGIN

@interface LEOCachedDataStore : NSObject <LEOAsyncDataSource, LEOSyncronousDataSource>

+ (instancetype)sharedInstance;
- (void)reset;

NS_ASSUME_NONNULL_END
@end

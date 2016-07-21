//
//  LEOCachedDataStore.h
//  Leo
//
//  Created by Adam Fanslau on 2/23/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Practice, Family;

@interface LEOCachedDataStore : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (strong, nonatomic, nullable) Practice *practice;
@property (strong, nonatomic, nullable) Family *family;
@property (strong, nonatomic, nullable) NSArray *notices;

@property (strong, nonatomic, nullable) NSDate *lastCachedDateForPractice;
@property (strong, nonatomic, nullable) NSDate *lastCachedDateForNotices;

+ (instancetype)sharedInstance;
- (void)reset;

NS_ASSUME_NONNULL_END
@end

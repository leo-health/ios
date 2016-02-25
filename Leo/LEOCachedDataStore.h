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

@property (strong, nonatomic) Practice *practice;
@property (strong, nonatomic) Family *family;

@property (strong, nonatomic) NSDate *lastCachedDateForPractice;

+ (instancetype)sharedInstance;
- (void)reset;

@end

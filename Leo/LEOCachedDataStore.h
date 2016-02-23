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

+ (instancetype)sharedInstance;
- (void)reset;

@end

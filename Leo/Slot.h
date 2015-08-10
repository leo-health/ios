//
//  Slot.h
//  LEOCalendar
//
//  Created by Zachary Drossman on 7/30/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Slot : NSObject

@property (strong, nonatomic) NSDate *startDateTime;
@property (strong, nonatomic) NSNumber *duration;
@property (strong, nonatomic) NSNumber *providerID;
@property (strong, nonatomic) NSNumber *practiceID;

- (instancetype)initWithStartDateTime:(NSDate *)startDateTime duration:(NSNumber *)duration providerID:(NSNumber *)providerID practiceID:(NSNumber *)practiceID;
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

@end

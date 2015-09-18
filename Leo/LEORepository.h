//
//  LEORepository.h
//  Leo
//
//  Created by Zachary Drossman on 8/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//


//Purpose of this class is to observe changes to various data and make changes / updates to various data as needed as a result of these observations (e.g. appointment is booked; requires update to feed of cards. May implement some low level caching (e.g. time-based refresh checks). May support an NSOperationQueue of tasks that are used in parallel to fetch / update data, independent of the view controllers which request the data / receive the data.

#import <Foundation/Foundation.h>
#import "LEOAppointmentService.h"

@interface LEORepository : NSObject

@property (strong, nonatomic) NSArray *slots;

@end

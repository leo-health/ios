//
//  PracticeScheduleException.h
//  Leo
//
//  Created by Zachary Drossman on 4/26/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOJSONSerializable.h"

@interface PracticeScheduleException : LEOJSONSerializable
NS_ASSUME_NONNULL_BEGIN

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

NS_ASSUME_NONNULL_END
@end

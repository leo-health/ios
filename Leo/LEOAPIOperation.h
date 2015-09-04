//
//  LEOAPIOperation.h
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/6/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOAPIOperation : NSOperation

@property (copy, nonatomic) void (^requestBlock)(id data, NSError *error);

@end

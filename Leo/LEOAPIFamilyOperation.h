//
//  LEOAPIFamilyOperation.h
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/6/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOAPIOperation.h"
#import "LEOCachePolicy.h"

@interface LEOAPIFamilyOperation : LEOAPIOperation

- (instancetype)initWithCachePolicy:(LEOCachePolicy *)cachePolicy;

@end

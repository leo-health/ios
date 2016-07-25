//
//  LEOAPIFamilyOperation.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/6/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOAPIFamilyOperation.h"
#import "Family.h"
#import "LEOFamilyService.h"
#import "LEOSession.h"

@interface LEOAPIFamilyOperation ()

@property (strong, nonatomic) LEOCachePolicy *cachePolicy;

@end

@implementation LEOAPIFamilyOperation

- (instancetype)initWithCachePolicy:(LEOCachePolicy *)cachePolicy {

    self = [super init];
    if (self) {
        _cachePolicy = cachePolicy;
    }
    return self;
}

-(void)main {

    [[LEOFamilyService serviceWithCachePolicy:self.cachePolicy] getFamilyWithCompletion:^(Family *family, NSError *error) {

        // for appointments, sort by youngest to oldest
        NSArray *data = [family.patients sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dob" ascending:NO],[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]]];

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.requestBlock(data, error);
        }];
    }];
}

@end

//
//  LEOAPIFamilyOperation.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/6/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOAPIFamilyOperation.h"
#import "Family.h"
#import "LEOHelperService.h"
#import "LEOCachedDataStore.h"

@implementation LEOAPIFamilyOperation

-(void)main {

    void(^completion)(Family *, NSError *) = ^(Family * family, NSError *error) {

        // for appointments, sort by youngest to oldest
        NSArray *data = [family.patients sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dob" ascending:NO],[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]]];

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.requestBlock(data, error);
        }];
    };

    Family *cachedFamily = [LEOCachedDataStore sharedInstance].family;

    if (!cachedFamily) {

        [[LEOHelperService new] getFamilyWithCompletion:completion];
    } else {

        completion(cachedFamily, nil);
    }

}

@end

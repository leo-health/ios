//
//  LEOAPIStaffOperation.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/6/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOAPIStaffOperation.h"
#import "LEODataManager.h"
#import "Provider.h"

@implementation LEOAPIStaffOperation

-(void)main {
    
    LEODataManager *dataManager = [LEODataManager sharedManager];
    
    [dataManager getAllStaffForPracticeID:@"0" withCompletion:^(NSArray * staff) {
        
        NSPredicate *providerFilter = [NSPredicate predicateWithFormat:@"self isKindOfClass:%@",[Provider class]];
        
        id data = [staff filteredArrayUsingPredicate:providerFilter];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.requestBlock(data);
        }];
    }];
}

@end

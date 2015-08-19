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
#import "Practice.h"
@implementation LEOAPIStaffOperation

-(void)main {
    
    LEODataManager *dataManager = [LEODataManager sharedManager];
    
    [dataManager getPracticeWithID:@"0" withCompletion:^(Practice *practice) {
        
        NSPredicate *providerFilter = [NSPredicate predicateWithFormat:@"self isKindOfClass:%@",[Provider class]];
        
        id data = [practice.staff filteredArrayUsingPredicate:providerFilter];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.requestBlock(data);
        }];
    }];
}

@end

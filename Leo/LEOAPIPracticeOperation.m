//
//  LEOAPIStaffOperation.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/6/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOAPIPracticeOperation.h"
#import "LEOHelperService.h"
#import "Provider.h"
#import "Practice.h"
@implementation LEOAPIPracticeOperation

-(void)main {
    
    LEOHelperService *helperService = [[LEOHelperService alloc] init];
    
    [helperService getPracticeWithID:@"0" withCompletion:^(Practice *practice, NSError *error) {

        id data = practice.providers;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.requestBlock(data, error);
        }];
    }];
}

@end

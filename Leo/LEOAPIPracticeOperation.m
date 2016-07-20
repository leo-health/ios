//
//  LEOAPIStaffOperation.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/6/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOAPIPracticeOperation.h"
#import "LEOPracticeService.h"
#import "Provider.h"
#import "Practice.h"

@implementation LEOAPIPracticeOperation

-(void)main {
    
    [[LEOPracticeService new] getPracticeWithCompletion:^(Practice *practice, NSError *error) {

        id data = practice.providers;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.requestBlock(data, error);
        }];
    }];
}

@end

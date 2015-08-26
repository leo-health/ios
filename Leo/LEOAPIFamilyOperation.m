//
//  LEOAPIFamilyOperation.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/6/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOAPIFamilyOperation.h"
#import "Family.h"
#import "LEODataManager.h"

@implementation LEOAPIFamilyOperation

-(void)main {
    
    LEODataManager *dataManager = [LEODataManager sharedManager];
        
    [dataManager getFamilyWithCompletion:^(Family * family, NSError *error) {

        id data = family.patients;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.requestBlock(data, error);
        }];
    }];
}

@end

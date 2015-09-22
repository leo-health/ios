//
//  LEOAPIInsuranceOperation.m
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOAPIInsuranceOperation.h"
#import <OHHTTPStubs.h>
#import "InsurancePlan.h"
#import "LEOHelperService.h"
@implementation LEOAPIInsuranceOperation


-(void)main {
    
    InsurancePlan *plan = [[InsurancePlan alloc] initWithObjectID:@"1" insurerID:@"0" insurerName:@"Aetna" name:@"PPO"];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.requestBlock(@[plan], nil);
    }];
    
//    TODO:Replace the above with this once the endpoint no longer requires an auth token.
//    LEOHelperService *helperService = [[LEOHelperService alloc] init];
//    
//    [helperService getInsurersAndPlansWithCompletion:^(NSArray *insurersAndPlans, NSError *error) {
//        
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            self.requestBlock(insurersAndPlans, nil);
//        }];
//    }];
}

@end

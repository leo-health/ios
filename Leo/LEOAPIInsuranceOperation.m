//
//  LEOAPIInsuranceOperation.m
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOAPIInsuranceOperation.h"
#import "InsurancePlan.h"
#import "Insurer.h"
#import "LEOHelperService.h"
@implementation LEOAPIInsuranceOperation


-(void)main {
    
//    InsurancePlan *plan = [[InsurancePlan alloc] initWithObjectID:@"1" insurerID:@"0" insurerName:@"Aetna" name:@"PPO"];
//    
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        self.requestBlock(@[plan], nil);
//    }];
//    
//    TODO:Replace the above with this once the endpoint no longer requires an auth token.
    LEOHelperService *helperService = [[LEOHelperService alloc] init];
    
    [helperService getInsurersAndPlansWithCompletion:^(NSArray *insurersAndPlans, NSError *error) {
        
        NSMutableArray *insurancePlans = [NSMutableArray new];
        
        for (Insurer *insurer in insurersAndPlans) {
            
            [insurancePlans addObjectsFromArray:insurer.plans];
        }

        NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"combinedName" ascending:YES];

        NSArray *sortedInsurancePlans = [insurancePlans sortedArrayUsingDescriptors:@[sortByName]];

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.requestBlock(sortedInsurancePlans, nil);
        }];
    }];
}

@end

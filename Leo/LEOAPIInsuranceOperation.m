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
#import "LEOPracticeService.h"
@implementation LEOAPIInsuranceOperation


-(void)main {
    
    [[LEOPracticeService new] getInsurersAndPlansWithCompletion:^(NSArray *insurers, NSError *error) {

        NSMutableArray *insurancePlans = [NSMutableArray new];
        for (Insurer *insurer in insurers) {
            [insurancePlans addObjectsFromArray:insurer.plans];
        }

        NSSortDescriptor *sortByName =
        [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(combinedName))
                                      ascending:YES];
        NSArray *sortedInsurancePlans =
        [insurancePlans sortedArrayUsingDescriptors:@[sortByName]];

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.requestBlock(sortedInsurancePlans, nil);
        }];
    }];
}

@end

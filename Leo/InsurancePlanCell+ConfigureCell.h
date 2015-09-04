//
//  InsurerCell+ConfigureCell.h
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "InsurancePlanCell.h"

@class InsurancePlan;

@interface InsurancePlanCell (ConfigureCell)

- (void)configureForPlan:(InsurancePlan *)plan;

@end

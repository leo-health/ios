//
//  LEOPHRVitalChartCell.h
//  Leo
//
//  Created by Zachary Drossman on 4/7/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOVitalGraphViewController.h"
#import "UITableViewCell+Extensions.h"

@interface LEOPHRVitalChartCell : UITableViewCell

@property (strong, nonatomic) NSArray *vitalData;
@property (strong, nonatomic) UIView *hostedGraphView;

@end

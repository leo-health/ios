//
//  LEOPHRVitalsCell.h
//  Leo
//
//  Created by Zachary Drossman on 4/7/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOVitalGraphViewController.h"

@interface LEOPHRVitalsCell : UITableViewCell

@property (strong, nonatomic) NSArray *vitalData;
@property (strong, nonatomic) UIView *hostedGraphView;

+ (UINib *)nib;

@end

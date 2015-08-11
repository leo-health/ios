//
//  AppointmentTypeCell.h
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/5/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentTypeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic) UIColor *selectedColor;

+(UINib *)nib;

@end

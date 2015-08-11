//
//  ProviderCell.h
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/5/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProviderCell : UITableViewCell

+(UINib *)nib;

@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (strong, nonatomic) UIColor *selectedColor;

@end

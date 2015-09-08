//
//  InsurerCell.h
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsurancePlanCell : UITableViewCell

+(UINib *)nib;

@property (weak, nonatomic) IBOutlet UILabel *insurancePlanLabel;
@property (strong, nonatomic) UIColor *selectedColor;

@end

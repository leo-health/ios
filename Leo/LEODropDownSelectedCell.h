//
//  LEODropDownSelectedCell.h
//  Leo
//
//  Created by Zachary Drossman on 6/10/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEODropDownSelectedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *selectedLabel;

+ (UINib *)nib;

@end

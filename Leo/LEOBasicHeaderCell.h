//
//  LEOBasicHeaderCell.h
//  Leo
//
//  Created by Zachary Drossman on 10/5/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEOBasicHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

+ (UINib *)nib;

@end

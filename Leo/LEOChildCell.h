//
//  LEOChildCell.h
//  Leo
//
//  Created by Zachary Drossman on 6/13/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEOChildCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
+ (UINib *)nib;

@end

//
//  LEOOneButtonPrimaryAndSecondaryCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOOneButtonPrimaryAndSecondaryCell.h"
#import "UIButton+Extensions.h"

@implementation LEOOneButtonPrimaryAndSecondaryCell

- (void)awakeFromNib {
    
    self.bodyView.layer.cornerRadius = kCornerRadius;
    self.bodyView.layer.masksToBounds = YES;
    
    [self.bodyView.layer setShouldRasterize:YES];
    [self.bodyView.layer setRasterizationScale:[UIScreen mainScreen].scale];

    [self.buttonOne leo_styleDisabledState];
}

+ (UINib *)nib {
    
    return [UINib nibWithNibName:@"LEOOneButtonPrimaryAndSecondaryCell" bundle:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end

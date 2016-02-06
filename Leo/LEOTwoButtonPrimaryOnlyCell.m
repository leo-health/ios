//
//  LEOPrimaryOnlyCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/10/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOTwoButtonPrimaryOnlyCell.h"
#import "UIButton+Extensions.h"
@implementation LEOTwoButtonPrimaryOnlyCell

- (void)awakeFromNib {
    
    self.bodyView.layer.cornerRadius = kCornerRadius;
    self.bodyView.layer.masksToBounds = YES;
    
    [self.bodyView.layer setShouldRasterize:YES];
    [self.bodyView.layer setRasterizationScale:[UIScreen mainScreen].scale];

    [self.buttonOne leo_styleDisabledState];
    [self.buttonTwo leo_styleDisabledState];
}

+ (UINib *)nib {
    
    return [UINib nibWithNibName:@"LEOTwoButtonPrimaryOnlyCell" bundle:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}




@end

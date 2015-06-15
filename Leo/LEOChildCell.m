//
//  LEOChildCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/13/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOChildCell.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"

@implementation LEOChildCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (UINib *)nib {
    return [UINib nibWithNibName:@"LEOChildCell" bundle:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.checkImageView.hidden = NO;
        self.nameLabel.textColor = [UIColor leoOrangeRed];
        self.nameLabel.font = [UIFont leoTitleBolderFont];
    } else {
        self.checkImageView.hidden = YES;
        self.nameLabel.textColor = [UIColor leoWarmHeavyGray];
        self.nameLabel.font = [UIFont leoTitleBasicFont];
    }
    
}

@end

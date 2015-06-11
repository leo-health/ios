//
//  LEOTimeCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/1/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOTimeCell.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"

@implementation LEOTimeCell

-(void)awakeFromNib {
    
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.timeLabel.textColor = [UIColor leoOrangeRed];

    [self setUnselectedFormat];
}

-(void)setSelected:(BOOL)selected {
    
    [self setSelectedFormat];
    
    if (!selected) {
        [self setUnselectedFormat];
    }
    
    [self layoutIfNeeded];
    
}


- (void)setUnselectedFormat {
    
    self.timeLabel.font = [UIFont leoBodyBasicFont];
    self.checkImageView.hidden = YES;
}

- (void)setSelectedFormat {
    
    self.timeLabel.font = [UIFont leoBodyBolderFont];
    self.checkImageView.hidden = NO;
}



@end


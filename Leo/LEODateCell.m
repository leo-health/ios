//
//  LEODateCell.m
//
//
//  Created by Zachary Drossman on 6/1/15.
//
//

#import "LEODateCell.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
@implementation LEODateCell

-(void)awakeFromNib {
    
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
    
    self.dateLabel.font = [UIFont leoTitleBasicFont];
    self.dateLabel.textColor = [UIColor leoWarmHeavyGray];
    self.dayOfDateLabel.textColor = [UIColor leoWarmHeavyGray];
    self.backgroundColor = [UIColor leoWarmLightGray];
}

- (void)setSelectedFormat {
    
    self.dateLabel.font = [UIFont leoTitleBolderFont];
    self.dateLabel.textColor = [UIColor leoOrangeRed];
    self.dayOfDateLabel.textColor = [UIColor leoWarmHeavyGray];
    self.dayOfDateLabel.font = [UIFont leoBodyBoldFont];
    self.backgroundColor = [UIColor leoWhite];
}

@end
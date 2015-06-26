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
    
    super.selected = selected;
    
    if (!selected) {
        [self setUnselectedFormat];
    } else {
        [self setSelectedFormat];
    }
    
    [self layoutIfNeeded];
}

-(void)setSelectable:(BOOL)selectable {
    
    _selectable = selectable;
    
    if (!_selectable) {
        [self setUnselectableFormat];
    } else {
        [self setSelectableFormat];
    }
}

- (void)setUnselectableFormat {
    
    self.userInteractionEnabled = NO;
    self.dateLabel.textColor = [UIColor leoWhite];
}

- (void)setSelectableFormat {
    
    self.userInteractionEnabled = YES;
    self.dateLabel.textColor = [UIColor leoWarmHeavyGray];
}

- (void)setUnselectedFormat {
    
    self.dateLabel.font = [UIFont leoTitleBasicFont];
    self.dateLabel.textColor = [UIColor leoWarmHeavyGray];
    self.dayOfDateLabel.textColor = [UIColor leoWarmHeavyGray];
    self.dayOfDateLabel.font = [UIFont leoBodyBasicFont];
    self.backgroundColor = [UIColor leoWarmLightGray];
    
}

- (void)setSelectedFormat {

    self.selectable = YES;
    [self setSelectableFormat];
    
    self.dateLabel.font = [UIFont leoTitleBolderFont];
    self.dateLabel.textColor = [UIColor leoOrangeRed];
    self.dayOfDateLabel.textColor = [UIColor leoWarmHeavyGray];
    self.dayOfDateLabel.font = [UIFont leoBodyBoldFont];
    self.backgroundColor = [UIColor leoWhite];
}


@end
//
//  BasicSelectedCell.m
//  TableViewMeat
//
//  Created by Zachary Drossman on 6/8/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEODropDownSelectionCell.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"

@implementation LEODropDownSelectionCell

- (void)awakeFromNib {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.optionLabel.textColor = [UIColor leoOrangeRed];
    self.optionLabel.font = [UIFont leoTitleBasicFont];
}

+ (UINib *)nib {
    
    return [UINib nibWithNibName:@"SelectionCell" bundle:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self formatSelected];
    } else {
        [self formatUnselected];
    }
    
    [self setNeedsDisplay];
}

- (void)formatSelected {
    
    self.checkListImageView.hidden = NO;
    self.optionLabel.textColor = [UIColor leoOrangeRed];
    self.optionLabel.font = [UIFont leoTitleBolderFont];
}

- (void)formatUnselected {
    
    self.checkListImageView.hidden = YES;
    self.optionLabel.textColor = [UIColor leoWarmHeavyGray];
    self.optionLabel.font = [UIFont leoTitleBasicFont];
}

@end

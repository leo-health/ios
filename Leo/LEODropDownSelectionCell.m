//
//  BasicSelectedCell.m
//  TableViewMeat
//
//  Created by Zachary Drossman on 6/8/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEODropDownSelectionCell.h"


@implementation LEODropDownSelectionCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        [self formatSelected];
    } else {
        [self formatUnselected];
    }
    
    [self setNeedsDisplay];
    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        [self formatSelected];
    } else {
        [self formatUnselected];
    }
    
}
- (void)formatSelected {
    self.checkListImageView.hidden = NO;
}

- (void)formatUnselected {
    self.checkListImageView.hidden = YES;
}
@end

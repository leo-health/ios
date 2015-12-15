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


@interface LEOTimeCell()

@property (strong, nonatomic) CALayer *bottomBorder;

@end

@implementation LEOTimeCell

-(void)awakeFromNib {
    
    [self setUnselectedFormat];
}

-(void)setSelected:(BOOL)selected {
    
    super.selected = selected;
    
    [self setSelectedFormat];
    
    if (!selected) {
        [self setUnselectedFormat];
    }
    
    [self layoutIfNeeded];
}

- (void)setUnselectedFormat {
    
    [self.bottomBorder removeFromSuperlayer];
    [self updateLabel:self.timeLabel withColor:[UIColor leo_grayStandard]];
    self.checkImageView.hidden = YES;
}

- (void)setSelectedFormat {
    
    [self.layer addSublayer:self.bottomBorder];
    
    [self updateLabel:self.timeLabel withColor:[UIColor leo_green]];
    self.checkImageView.hidden = NO;
}

-(CALayer *)bottomBorder {
    
    if (!_bottomBorder) {
        
        _bottomBorder = [CALayer layer];
        _bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - kSelectionLineHeight, self.frame.size.width, kSelectionLineHeight);
        _bottomBorder.backgroundColor = [UIColor leo_green].CGColor;
    }
    
    return _bottomBorder;
    
}

- (void)updateLabel:(UILabel *)label withColor:(UIColor *)color {
    
    NSMutableAttributedString *dateString = [label.attributedText mutableCopy];
    
    [dateString beginEditing];
    
    [dateString addAttribute:NSForegroundColorAttributeName
                       value:color
                       range:NSMakeRange(0, [dateString length])];
    
    [dateString endEditing];
    
    label.attributedText = dateString;
}

@end


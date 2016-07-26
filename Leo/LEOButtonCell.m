//
//  LEOButtonCell.m
//  
//
//  Created by Zachary Drossman on 10/5/15.
//
//

#import "LEOButtonCell.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "UIButton+Extensions.h"
#import "LEOStyleHelper.h"

@implementation LEOButtonCell

CGFloat const kCellHeightButton = 94;

- (void)awakeFromNib {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self styleButton];
}

+ (UINib *)nib {
    
    return [UINib nibWithNibName:@"LEOButtonCell" bundle:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)styleButton {

    [self.button leo_styleDisabledState];

    [self.button setTitleColor:[UIColor leo_white] forState:UIControlStateNormal];
    self.button.backgroundColor = [UIColor leo_orangeRed];
    self.button.titleLabel.font = [UIFont leo_medium12];

    [LEOStyleHelper roundCornersForView:self.button withCornerRadius:kCornerRadius];
}


@end

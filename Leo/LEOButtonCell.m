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

@implementation LEOButtonCell

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
    
    [self.button setTitleColor:[UIColor leoWhite] forState:UIControlStateNormal];
    self.button.backgroundColor = [UIColor leoOrangeRed];
    self.button.titleLabel.font = [UIFont leoButtonLabelsAndTimeStampsFont];
    
}
@end

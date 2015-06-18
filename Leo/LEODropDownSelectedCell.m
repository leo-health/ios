//
//  LEODropDownSelectedCell.m
//
//
//  Created by Zachary Drossman on 6/16/15.
//
//

#import "LEODropDownSelectedCell.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"

@implementation LEODropDownSelectedCell

- (void)awakeFromNib {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.selectedLabel.textColor = [UIColor leoOrangeRed];
    self.selectedLabel.font = [UIFont leoTitleBasicFont];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

+ (UINib *)nib {
    
    return [UINib nibWithNibName:@"SelectedCell" bundle:nil];
}

@end

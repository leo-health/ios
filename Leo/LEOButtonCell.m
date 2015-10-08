//
//  LEOButtonCell.m
//  
//
//  Created by Zachary Drossman on 10/5/15.
//
//

#import "LEOButtonCell.h"

@implementation LEOButtonCell

- (void)awakeFromNib {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (UINib *)nib {
    
    return [UINib nibWithNibName:@"LEOButtonCell" bundle:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

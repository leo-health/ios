//
//  LEOPromptViewCell.m
//  Leo
//
//  Created by Zachary Drossman on 9/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOPromptViewCell.h"

@implementation LEOPromptViewCell

- (void)awakeFromNib {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+(UINib *)nib {
    
    return [UINib nibWithNibName:@"PatientCell" bundle:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

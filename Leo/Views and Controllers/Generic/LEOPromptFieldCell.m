//
//  LEOPromptFieldCell.m
//  Leo
//
//  Created by Zachary Drossman on 12/16/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOPromptFieldCell.h"

@implementation LEOPromptFieldCell

- (void)awakeFromNib {

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+(UINib *)nib {

    return [UINib nibWithNibName:@"LEOPromptFieldCell" bundle:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

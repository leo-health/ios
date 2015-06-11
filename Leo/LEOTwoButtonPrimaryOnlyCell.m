//
//  LEOPrimaryOnlyCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/10/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOTwoButtonPrimaryOnlyCell.h"

@implementation LEOTwoButtonPrimaryOnlyCell

- (void)awakeFromNib {
    // Initialization code
}

+ (UINib *)nib {
    return [UINib nibWithNibName:@"LEOTwoButtonPrimaryOnlyCell" bundle:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

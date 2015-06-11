//
//  LEOOneButtonPrimaryOnlyCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOOneButtonPrimaryOnlyCell.h"

@implementation LEOOneButtonPrimaryOnlyCell

- (void)awakeFromNib {
    // Initialization code
}

+ (UINib *)nib {
    return [UINib nibWithNibName:@"LEOOneButtonPrimaryOnlyCell" bundle:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  ProviderCell.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/5/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "ProviderCell.h"

@implementation ProviderCell

- (void)awakeFromNib {
    // Initialization code
}

+(UINib *)nib {
    
    return [UINib nibWithNibName:@"ProviderCell" bundle:nil];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

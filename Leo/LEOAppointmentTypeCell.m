//
//  LEOAppointmentTypeCell.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/3/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOAppointmentTypeCell.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"

@implementation LEOAppointmentTypeCell

- (void)awakeFromNib {

    [self formatCell];
}

+ (UINib *)nib {
   return [UINib nibWithNibName:@"LEOAppointmentTypeCell" bundle:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)formatCell {
    
    self.shortDescriptionLabel.font = [UIFont leoTitleBoldFont];
    self.shortDescriptionLabel.textColor = [UIColor leoGrayTitleText];
    self.longDescriptionLabel.font = [UIFont leoTitleBasicFont];
    self.longDescriptionLabel.textColor = [UIColor leoGrayBodyText];
}

@end

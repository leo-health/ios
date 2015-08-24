//
//  AppointmentTypeCell.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/5/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "AppointmentTypeCell.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
@implementation AppointmentTypeCell

- (void)awakeFromNib {

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self formatCell];
}

+(UINib *)nib {

    return [UINib nibWithNibName:@"AppointmentTypeCell" bundle:nil];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    if (selected) {
        
        NSMutableAttributedString *appointmentType = [self.nameLabel.attributedText mutableCopy];
        
        NSRange range = NSMakeRange(0, [appointmentType length]);
        
        [appointmentType beginEditing];
        
        [appointmentType addAttribute:NSUnderlineStyleAttributeName value:@(selectionLineHeight) range:range];
        [appointmentType addAttribute:NSForegroundColorAttributeName value:self.selectedColor range:range];
        [appointmentType endEditing];
        
        self.nameLabel.attributedText = appointmentType;
    }
}


- (void)formatCell {
    
    self.nameLabel.font = [UIFont leoMenuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    self.nameLabel.textColor = [UIColor leoGrayStandard];
    self.descriptionLabel.font = [UIFont leoStandardFont];
    self.descriptionLabel.textColor = [UIColor leoGrayStandard];
}

@end

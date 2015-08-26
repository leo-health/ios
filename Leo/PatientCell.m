//
//  PatientCell.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/5/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "PatientCell.h"
#import "LEOMessagesAvatarImageFactory.h"

@implementation PatientCell

- (void)awakeFromNib {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+(UINib *)nib {
    
    return [UINib nibWithNibName:@"PatientCell" bundle:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    if (selected) {
        
        NSMutableAttributedString *patient = [self.fullNameLabel.attributedText mutableCopy];
        
        NSRange range = NSMakeRange(0, [patient length]);
        
        [patient beginEditing];
        
        [patient addAttribute:NSUnderlineStyleAttributeName value:@(selectionLineHeight) range:range];
        [patient addAttribute:NSForegroundColorAttributeName value:self.selectedColor range:range];
        [patient endEditing];
        
        self.fullNameLabel.attributedText = patient;
        
        [self.avatarImageView setImage:[LEOMessagesAvatarImageFactory circularAvatarImage:self.avatarImageView.image withDiameter:40 borderColor:self.selectedColor borderWidth:3]];
         //TODO: Placeholder for what is necessary here for a selected state.
    }
}

@end

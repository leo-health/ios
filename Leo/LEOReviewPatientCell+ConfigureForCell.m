//
//  LEOReviewPatientCell+ConfigureForCell.m
//  Leo
//
//  Created by Zachary Drossman on 10/5/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOReviewPatientCell+ConfigureForCell.h"
#import "Patient.h"
#import "NSDate+Extensions.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "LEOMessagesAvatarImageFactory.h"

@implementation LEOReviewPatientCell (ConfigureForCell)


/**
 *  Fills out the UITableViewCell with data provided by the controller.
 *
 *  @param patient          the patient to be displayed in the cell
 *  @param patientNumber    the number of the patient, determined by placement in the patients array
 */
- (void)configureForPatient:(Patient *)patient patientNumber:(NSInteger)patientNumber {
    
    self.nameLabel.text = patient.fullName;
    self.birthDateLabel.text = [NSDate leo_stringifiedShortDate:patient.dob];

    //MARK: Leaving the below here in case we want to implement this again.
//    self.editButton.hidden = patientNumber > 0 ? YES : NO;
    
    self.avatarImageView.image = [LEOMessagesAvatarImageFactory circularAvatarImage:patient.avatar withDiameter:36 borderColor:[UIColor leo_orangeRed] borderWidth:1.0];

    [self setPatientCopyFontAndColor];
}

- (void)setPatientCopyFontAndColor {
    
    self.nameLabel.font = [UIFont leo_collapsedCardTitlesFont];
    self.nameLabel.textColor = [UIColor leo_grayStandard];

    self.birthDateLabel.font = [UIFont leo_standardFont];
    self.birthDateLabel.textColor = [UIColor leo_grayStandard];
    
    self.editButton.titleLabel.font = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont];
    [self.editButton setTitleColor:[UIColor leo_orangeRed] forState:UIControlStateNormal];
}

@end

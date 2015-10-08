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
    self.birthDateLabel.text = [NSDate stringifiedShortDate:patient.dob];

    //MARK: Leaving the below here in case we want to implement this again.
//    self.editButton.hidden = patientNumber > 0 ? YES : NO;
    
    self.avatarImageView.image = [LEOMessagesAvatarImageFactory circularAvatarImage:patient.avatar withDiameter:36 borderColor:[UIColor leoOrangeRed] borderWidth:1.0];

    [self setPatientCopyFontAndColor];
}

- (void)setPatientCopyFontAndColor {
    
    self.nameLabel.font = [UIFont leoCollapsedCardTitlesFont];
    self.nameLabel.textColor = [UIColor leoGrayStandard];

    self.birthDateLabel.font = [UIFont leoStandardFont];
    self.birthDateLabel.textColor = [UIColor leoGrayStandard];
    
    self.editButton.titleLabel.font = [UIFont leoFieldAndUserLabelsAndSecondaryButtonsFont];
    [self.editButton setTitleColor:[UIColor leoOrangeRed] forState:UIControlStateNormal];
}

@end

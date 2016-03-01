//
//  LEOPHRTableViewCell.h
//  Leo
//
//  Created by Adam Fanslau on 1/7/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

@class Patient, PatientVitalMeasurement, Allergy, Medication, Immunization, PatientNote;

#import <UIKit/UIKit.h>

@interface LEOPHRTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *recordTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordTitleDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordMainDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordSideLabel;

+ (UINib *)nib;

- (void)configureCellWithVital:(PatientVitalMeasurement *)vital title:(NSString *)title;
- (void)configureCellWithAllergy:(Allergy *)allergy;
- (void)configureCellWithMedication:(Medication *)medication;
- (void)configureCellWithImmunization:(Immunization *)immunization;
- (void)configureCellWithNote:(PatientNote *)note;
- (void)configureCellForEmptyRecordWithPatient:(Patient *)patient;
- (void)configureCellForEmptySectionWithMessage:(NSString *)message;


@end

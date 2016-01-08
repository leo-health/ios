//
//  PHRTableViewCell.m
//  Leo
//
//  Created by Adam Fanslau on 1/7/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOPHRTableViewCell.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"

@implementation LEOPHRTableViewCell

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
}

- (void)awakeFromNib {

    self.recordTitleLabel.font = [UIFont leo_standardFont];
    self.recordTitleLabel.textColor = [UIColor leo_grayForTitlesAndHeadings];

    self.recordSideLabel.font = [UIFont leo_standardFont];
    self.recordSideLabel.textColor = [UIColor leo_grayForTitlesAndHeadings];

    self.recordMainDetailLabel.font = [UIFont leo_standardFont];
    self.recordMainDetailLabel.textColor = [UIColor leo_grayStandard];

    self.recordTitleDetailLabel.font = [UIFont leo_standardFont];
    self.recordTitleDetailLabel.textColor = [UIColor leo_grayStandard];
}

- (void)configureCellWithVitals:(PatientVitalMeasurement *)vital {

    self.recordTitleDetailLabel.text = nil;
    // FIXME: where does this information come from?
    self.recordSideLabel.text = @"NORMAL";
    self.recordMainDetailLabel.text = [NSString stringWithFormat:@"%@ %@ percentile", vital.value, vital.percentile];
}

- (void)configureCellWithBMI:(PatientVitalMeasurementBMI *)bmi {

    // ????: this description may belong in the model
    self.recordTitleLabel.text = @"BMI";
    [self configureCellWithVitals:bmi];
}

- (void)configureCellWithHeight:(PatientVitalMeasurementHeight *)height {

    self.recordTitleLabel.text = @"Height";
    [self configureCellWithVitals:height];
}

- (void)configureCellWithWeight:(PatientVitalMeasurementWeight *)weight {

    self.recordTitleLabel.text = @"Weight";
    [self configureCellWithVitals:weight];
}

- (void)configureCellWithAllergy:(Allergy *)allergy {

    self.recordTitleLabel.text = allergy.allergen;
    self.recordTitleDetailLabel.text = nil;
    self.recordSideLabel.text = allergy.severity;
    self.recordMainDetailLabel.text = allergy.note;
}

- (void)configureCellWithMedication:(Medication *)medication {

    self.recordTitleLabel.text = medication.medication;
    self.recordTitleDetailLabel.text = nil;
    self.recordSideLabel.text = medication.frequency;
    self.recordMainDetailLabel.text = medication.note;
}

- (void)configureCellWithImmunization:(Immunization *)immunization {

    self.recordTitleLabel.text = immunization.vaccine;
    // TODO: fill with dosage
    self.recordTitleDetailLabel.text = nil;
    // TODO: date formatting
    self.recordSideLabel.text = [NSString stringWithFormat:@" - %@", immunization.administeredAt];
    self.recordMainDetailLabel.text = nil;
}


@end

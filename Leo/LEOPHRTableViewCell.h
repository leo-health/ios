//
//  LEOPHRTableViewCell.h
//  Leo
//
//  Created by Adam Fanslau on 1/7/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthRecord.h"

@interface LEOPHRTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *recordTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordTitleDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordMainDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordSideLabel;

+ (UINib *)nib;

- (void)configureCellWithBMI:(PatientVitalMeasurementBMI *)bmi;
- (void)configureCellWithHeight:(PatientVitalMeasurementHeight *)height;
- (void)configureCellWithWeight:(PatientVitalMeasurementWeight *)weight;
- (void)configureCellWithAllergy:(Allergy *)allergy;
- (void)configureCellWithMedication:(Medication *)medication;
- (void)configureCellWithImmunization:(Immunization *)immunization;

@end

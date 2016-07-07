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
#import "NSDate+Extensions.h"
#import "Patient.h"
#import "HealthRecord.h"
#import "PatientNote.h"
#import "NSString+Extensions.h"

@implementation LEOPHRTableViewCell

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
}

- (void)awakeFromNib {

    self.recordTitleLabel.font = [UIFont leo_regular15];
    self.recordTitleLabel.textColor = [UIColor leo_gray74];
    self.recordTitleLabel.numberOfLines = 0;
    self.recordTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;

    self.recordSideLabel.font = [UIFont leo_regular15];
    self.recordSideLabel.textColor = [UIColor leo_gray74];
    self.recordSideLabel.numberOfLines = 0;
    self.recordSideLabel.lineBreakMode = NSLineBreakByWordWrapping;

    self.recordMainDetailLabel.font = [UIFont leo_regular15];
    self.recordMainDetailLabel.textColor = [UIColor leo_gray124];
    self.recordMainDetailLabel.numberOfLines = 0;
    self.recordMainDetailLabel.lineBreakMode = NSLineBreakByWordWrapping;

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureCellWithVital:(PatientVitalMeasurement *)vital  title:(NSString *)title {

    if (vital) {
        self.recordTitleLabel.text = title;
        NSMutableString *str = [NSMutableString new];

        if (vital.valueAndUnitFormatted) {
            [str appendString:vital.valueAndUnitFormatted];
        }

        if (vital.percentile) {

            NSString *percentileSuffix = [NSString leo_numericSuffix:[vital.percentile integerValue]];
            [str appendString:[NSString stringWithFormat:@", %@%@ percentile",vital.percentile, percentileSuffix]];
        }

        self.recordMainDetailLabel.text = [str copy];
    }

    self.recordSideLabel.text = nil;
}

- (void)configureCellForEmptySectionWithMessage:(NSString *)message {

    self.recordTitleLabel.text = nil;
    self.recordSideLabel.text = nil;
    self.recordMainDetailLabel.text = message;
}

- (void)prepareForReuse {

    self.recordSideLabel.text = @"";
    self.recordTitleLabel.text = @"";
    self.recordMainDetailLabel.text = @"";
}

- (void)configureCellWithAllergy:(Allergy *)allergy {

    self.recordTitleLabel.text = allergy.allergen;
    self.recordSideLabel.text = allergy.severity;
    self.recordMainDetailLabel.text = allergy.note;
}

- (void)configureCellWithMedication:(Medication *)medication {

    self.recordTitleLabel.text = medication.medication;
    self.recordSideLabel.text = nil;
    self.recordMainDetailLabel.text = medication.sig;
}

- (void)configureCellWithImmunization:(Immunization *)immunization {

    self.recordTitleLabel.text = immunization.vaccine;
    self.recordMainDetailLabel.text = nil;
    // TODO: date formatting
    self.recordSideLabel.text = [NSDate leo_stringifiedDate:immunization.administeredAt withFormat:@"M/d/YY"];
}

- (void)configureCellWithNote:(PatientNote *)note {

    self.recordMainDetailLabel.text = note.text;
    self.recordTitleLabel.text = nil;
    self.recordSideLabel.text = nil;
}

- (void)configureCellForEmptyRecordWithPatient:(Patient *)patient {

    self.recordTitleLabel.text = nil;
    self.recordSideLabel.text = nil;

    NSString *emptyRecordString = [NSString stringWithFormat:@"As your %@'s data becomes available, this section will populate with important facts and figures related to %@ health and development.", [patient genderSpecificChildRelationship], [patient possessiveSingularGender]];

    self.recordMainDetailLabel.text = emptyRecordString;
}

@end

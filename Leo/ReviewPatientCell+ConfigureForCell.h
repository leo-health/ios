//
//  ReviewPatientCell+ConfigureForCell.h
//  Leo
//
//  Created by Zachary Drossman on 10/5/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class Patient;

#import "ReviewPatientCell.h"

@interface ReviewPatientCell (ConfigureForCell)

- (void)configureForPatient:(Patient *)patient patientNumber:(NSInteger)patientNumber;

@end

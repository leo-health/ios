//
//  PatientCell+ConfigureCell.h
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/5/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "PatientCell.h"

@class Patient;

@interface PatientCell (ConfigureCell)

- (void)configureForPatient:(Patient *)patient;

@end

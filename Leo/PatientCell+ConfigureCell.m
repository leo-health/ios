//
//  PatientCell+ConfigureCell.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/5/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "PatientCell+ConfigureCell.h"
#import "Patient.h"

@implementation PatientCell (ConfigureCell)


- (void)configureForPatient:(Patient *)patient {
    
    self.fullNameLabel.text = patient.fullName;
    self.avatarImageView.image = patient.avatar;
}

@end

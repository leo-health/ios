//
//  AppointmentTypeCell+ConfigureCell.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/5/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "AppointmentTypeCell+ConfigureCell.h"
#import "AppointmentType.h"
@implementation AppointmentTypeCell (ConfigureCell)

- (void)configureForAppointmentType:(AppointmentType *)appointmentType {
    
    self.nameLabel.text = [appointmentType.name capitalizedString];
    self.descriptionLabel.text = appointmentType.shortDescription;
}

@end

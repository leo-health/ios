//
//  LEOAppointmentTypeCell+ConfigureCell.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/3/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOAppointmentTypeCell+ConfigureCell.h"

@implementation LEOAppointmentTypeCell (ConfigureCell)

- (void)configureForAppointmentType:(AppointmentType *)appointmentType {
    
    self.shortDescriptionLabel.text = appointmentType.shortDescription;
    self.longDescriptionLabel.text = appointmentType.longDescription;
}
@end

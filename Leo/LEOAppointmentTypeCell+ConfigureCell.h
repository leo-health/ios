//
//  LEOAppointmentTypeCell+ConfigureCell.h
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/3/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOAppointmentTypeCell.h"
#import "AppointmentType.h"

@interface LEOAppointmentTypeCell (ConfigureCell)

- (void)configureForAppointmentType:(AppointmentType *)appointmentType;

@end

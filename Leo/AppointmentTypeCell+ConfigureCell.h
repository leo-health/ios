//
//  AppointmentTypeCell+ConfigureCell.h
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/5/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "AppointmentTypeCell.h"

@class AppointmentType;

@interface AppointmentTypeCell (ConfigureCell)

- (void)configureForAppointmentType:(AppointmentType *)appointmentType;

@end

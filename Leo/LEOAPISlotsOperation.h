//
//  LEOAPISlotsOperation.h
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/6/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOAPIOperation.h"

@class Appointment;

@interface LEOAPISlotsOperation : LEOAPIOperation

-(instancetype)initWithAppointment:(Appointment *)appointment;

@end

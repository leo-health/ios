//
//  LEOAPISlotsOperation.h
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/6/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOAPIOperation.h"

@class PrepAppointment;

@interface LEOAPISlotsOperation : LEOAPIOperation

-(instancetype)initWithPrepAppointment:(PrepAppointment *)prepAppointment;

@end

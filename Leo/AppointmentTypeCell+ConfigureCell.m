//
//  AppointmentTypeCell+ConfigureCell.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/5/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "AppointmentTypeCell+ConfigureCell.h"
#import "AppointmentType.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
@implementation AppointmentTypeCell (ConfigureCell)

- (void)configureForAppointmentType:(AppointmentType *)appointmentType {
    
    self.nameLabel.text = [appointmentType.name capitalizedString];
    self.nameLabel.textColor = [UIColor leo_grayForTitlesAndHeadings];
    self.nameLabel.font = [UIFont leo_medium15];
    self.descriptionLabel.text = appointmentType.shortDescription;
    self.descriptionLabel.textColor = [UIColor leo_grayStandard];
    self.descriptionLabel.font = [UIFont leo_regular15];
}

@end

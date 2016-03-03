//
//  LEOFeedCell+ConfigureForAppointmentCard.h
//  
//
//  Created by Zachary Drossman on 3/3/16.
//
//

@class LEOCardAppointment;

#import "LEOFeedCell.h"

@interface LEOFeedCell (ConfigureForAppointmentCard)

- (void)configureSubviewsForAppointmentCard:(LEOCardAppointment *)card;

@end

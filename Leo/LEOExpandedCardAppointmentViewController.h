//
//  LEOExpandedCardAppointmentViewController.h
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/3/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOExpandedCardViewController.h"
#import "LEOBasicSelectionViewController.h"
#import "LEOCardAppointment.h"

@interface LEOExpandedCardAppointmentViewController : LEOExpandedCardViewController <UIScrollViewDelegate, UITextViewDelegate, SingleSelectionProtocol, CardActivityProtocol>

@end

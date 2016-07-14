//
//  LEOAppointmentViewController.h
//  Leo
//
//  Created by Zachary Drossman on 11/24/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

@class LEOCardAppointment, LEOAnalyticSession;

#import "LEOStickyHeaderViewController.h"
#import "LEOAppointmentView.h"
#import "LEOBasicSelectionViewController.h"
#import "LEOExpandedCardViewProtocol.h"
#import "CardActivityProtocol.h"
#import "LEOAnalyticSessionManager.h"

@interface LEOAppointmentViewController : LEOStickyHeaderViewController <LEOStickyHeaderDataSource, LEOStickyHeaderDelegate, LEOAppointmentViewDelegate, SingleSelectionProtocol, LEOExpandedCardViewDelegate, CardActivityProtocol>

@property (weak, nonatomic) id<LEOExpandedCardViewDelegate>delegate;
@property (strong, nonatomic) LEOCardAppointment *card;

@end

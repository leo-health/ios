//
//  LEOAppointmentViewController.h
//  Leo
//
//  Created by Zachary Drossman on 11/24/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

@class LEOCard;

#import "LEOStickyHeaderView.h"
#import "LEOAppointmentView.h"
#import "LEOBasicSelectionViewController.h"

@interface LEOAppointmentViewController : UIViewController <StickyHeaderDataSource, LEOAppointmentViewDelegate, SingleSelectionProtocol>

@property (strong, nonatomic) LEOCard *card;
@property (nonatomic) Feature feature;

@end

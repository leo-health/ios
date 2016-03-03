//
//  LEOFeedCell+ConfigureForCard.h
//  Leo
//
//  Created by Zachary Drossman on 6/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOFeedCell.h"
#import "LEOFeedCell+ConfigureForAppointmentCard.h"

@class LEOCard;

@interface LEOFeedCell (ConfigureForCard)

- (void)configureForCard:(id<LEOCardProtocol>)card;

@end

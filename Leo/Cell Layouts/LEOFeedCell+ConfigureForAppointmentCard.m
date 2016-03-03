//
//  LEOFeedCell+ConfigureForAppointmentCard.m
//  
//
//  Created by Zachary Drossman on 3/3/16.
//
//

#import "LEOFeedCell+ConfigureForAppointmentCard.h"
#import "LEOFeedCellButtonView.h"
#import "UIView+Extensions.h"
#import "LEOCardAppointment.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "LEOPracticeDetailView.h"

@implementation LEOFeedCell (ConfigureForAppointmentCard)

- (void)configureSubviewsForAppointmentCard:(LEOCardAppointment *)card {

    [self appointment_configureFooterViewForCard:card];
    [self appointment_configureHeaderViewForCard:card];
    [self appointment_configureButtonViewForCard:card];
}

- (void)appointment_configureButtonViewForCard:(LEOCardAppointment *)card {

    LEOFeedCellButtonView *activityView = [[LEOFeedCellButtonView alloc] initWithCard:card];
    activityView.tintColor = self.tintColor;

    [activityView leo_pinToSuperView:self.buttonView];
}

- (void)appointment_configureHeaderViewForCard:(LEOCardAppointment *)card {

    UILabel *headerLabel = [UILabel new];

    [headerLabel leo_pinToSuperView:self.headerView];

    headerLabel.text = [[card primaryUser].firstName uppercaseString];
    headerLabel.font = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont];
    headerLabel.textColor = card.tintColor;
}

- (void)appointment_configureFooterViewForCard:(LEOCardAppointment *)card {

    LEOPracticeDetailView *practiceDetailView = [[LEOPracticeDetailView alloc] initWithPractice:card.practice];

    [practiceDetailView leo_pinToSuperView:self.footerView];
}

@end

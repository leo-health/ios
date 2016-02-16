//
//  LEOTwoButtonPrimaryAndSecondaryCell+ConfigureForCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOFeedCell+ConfigureForCell.h"
#import "LEOCardConversation.h"
#import "LEOCardAppointment.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "LEOCardUserView.h"
#import "LEOFeedCellButtonView.h"
#import "UIView+Extensions.h"
#import "LEOPracticeDetailView.h"
#import <NSDate+DateTools.h>

@implementation LEOFeedCell (ConfigureForCell)

- (void)configureForCard:(id<LEOCardProtocol>)card {

    self.contentView.backgroundColor = [UIColor leo_grayForMessageBubbles];

    self.iconImageView.image = [card icon];
    self.titleLabel.text = [card title];
    
    self.bodyLabel.text = [card body];

    [self configureFooterViewForCard:card];
    [self configureHeaderViewForCard:card];
    [self configureButtonViewForCard:card];

    [self formatSubviewsWithTintColor:card.tintColor];
    [self setCopyFontAndColor];
}

- (void)configureButtonViewForCard:(id<LEOCardProtocol>)card {

    if ([card isKindOfClass:[LEOCardAppointment class]]) {
        [self configureButtonViewForAppointmentCard:card];
    }

    if ([card isKindOfClass:[LEOCardConversation class]]) {
        [self configureButtonViewForConversationCard:card];
    }

}

- (void)configureButtonViewForAppointmentCard:(LEOCardAppointment *)card {

    LEOFeedCellButtonView *activityView = [[LEOFeedCellButtonView alloc] initWithCard:card];
    activityView.tintColor = self.tintColor;

    [activityView leo_pinToSuperView:self.buttonView];

    //TODO: Once we have this subclass IBDesignable, remove this.
    self.buttonView.backgroundColor = [UIColor clearColor];

}

- (void)configureButtonViewForConversationCard:(LEOCardAppointment *)card {

    LEOFeedCellButtonView *activityView = [[LEOFeedCellButtonView alloc] initWithCard:card];
    activityView.tintColor = self.tintColor;

    [activityView leo_pinToSuperView:self.buttonView];

    //TODO: Once we have this subclass IBDesignable, remove this.
    self.buttonView.backgroundColor = [UIColor clearColor];

}



- (void)configureHeaderViewForCard:(id<LEOCardProtocol>)card {

    if ([card isKindOfClass:[LEOCardAppointment class]]) {
        [self configureHeaderViewForAppointmentCard:card];
    }

    if ([card isKindOfClass:[LEOCardConversation class]]) {
        [self configureHeaderViewForConversationCard:card];
    }
}

- (void)configureHeaderViewForAppointmentCard:(LEOCardAppointment *)card {

    UILabel *headerLabel = [UILabel new];

    [headerLabel leo_pinToSuperView:self.headerView];

    headerLabel.text = [[card primaryUser].firstName uppercaseString];
    headerLabel.font = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont];
    headerLabel.textColor = card.tintColor;
    
    //TODO: Once we have this subclass IBDesignable, remove this.
    self.headerView.backgroundColor = [UIColor clearColor];
}

- (void)configureHeaderViewForConversationCard:(LEOCardConversation *)card {

    LEOCardUserView *userView = [[LEOCardUserView alloc] initWithUser:(Provider *)card.secondaryUser cardColor:card.tintColor];

    [userView leo_pinToSuperView:self.headerView];

    //TODO: Once we have this subclass IBDesignable, remove this.
    self.headerView.backgroundColor = [UIColor clearColor];
}

- (void)configureFooterViewForCard:(id<LEOCardProtocol>)card {

    if ([card isKindOfClass:[LEOCardAppointment class]]) {
        [self configureFooterViewForAppointmentCard:card];
    }

    if ([card isKindOfClass:[LEOCardConversation class]]) {
        [self configureFooterViewForConversationCard:card];
    }
}

- (void)configureFooterViewForAppointmentCard:(LEOCardAppointment *)card {

    LEOPracticeDetailView *practiceDetailView = [[LEOPracticeDetailView alloc] initWithPractice:card.practice];

    [practiceDetailView leo_pinToSuperView:self.footerView];

    //TODO: Once we have this subclass IBDesignable, remove this.
    self.footerView.backgroundColor = [UIColor clearColor];
}

- (void)configureFooterViewForConversationCard:(LEOCardConversation *)card {

    UILabel *timestampLabel = [UILabel new];

    [timestampLabel leo_pinToSuperView:self.footerView];

    timestampLabel.text = [NSString stringWithFormat:@"Sent %@",[card.timestamp.timeAgoSinceNow lowercaseString]];
    timestampLabel.textColor = [UIColor leo_grayForTimeStamps];
    timestampLabel.font = [UIFont leo_buttonLabelsAndTimeStampsFont];

    //TODO: Once we have this subclass IBDesignable, remove this.
    self.footerView.backgroundColor = [UIColor clearColor];
}

- (void)formatSubviewsWithTintColor:(UIColor *)tintColor {
    self.borderViewAtTopOfBodyView.backgroundColor = tintColor;
}

- (void)setCopyFontAndColor {

    self.bodyLabel.font = [UIFont leo_standardFont];
    self.bodyLabel.textColor = [UIColor leo_grayStandard];
}

@end

//
//  LEOFeedCell+ConfigureForCard.m
//  Leo
//
//  Created by Zachary Drossman on 6/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOFeedCell+ConfigureForCard.h"
#import "LEOCardConversation.h"
#import "LEOCardAppointment.h"
#import "LEOFormatting.h"
#import "LEOCardDeepLink.h"
#import "LEOCardUserView.h"
#import "LEOFeedCellButtonView.h"
#import "UIView+Extensions.h"
#import "LEOPracticeDetailView.h"
#import <DateTools/DateTools.h>
#import "LEOFeedCell+ConfigureForConversationCard.h"
#import "LEOFeedCell+ConfigureForAppointmentCard.h"
#import "LEOFeedCell+ConfigureForDeepLinkCard.h"

@implementation LEOFeedCell (ConfigureForCard)

- (void)configureForCard:(id<LEOCardProtocol>)card {

    self.contentView.backgroundColor = [UIColor leo_gray227];

    self.iconImageView.image = [card icon];
    self.titleLabel.text = [card title];
    self.bodyLabel.text = [card body];

    //TODO: Once we have this subclass IBDesignable, remove this.
    self.headerView.backgroundColor = [UIColor clearColor];
    self.buttonView.backgroundColor = [UIColor clearColor];
    self.footerView.backgroundColor = [UIColor clearColor];

    if ([card isKindOfClass:[LEOCardAppointment class]]) {
        [self configureSubviewsForAppointmentCard:card];
    }

    if ([card isKindOfClass:[LEOCardConversation class]]) {
        [self configureSubviewsForConversationCard:card];
    }

    if ([card isKindOfClass:[LEOCardDeepLink class]]) {
        [self configureSubviewsForDeepLinkCard:card];
    }

    [self configureButtonViewForCard:card];
    [self formatSubviewsWithTintColor:card.tintColor];
    [self setCopyFontAndColor];
}

- (void)configureButtonViewForCard:(id<LEOCardProtocol>)card {

    LEOFeedCellButtonView *activityView = [[LEOFeedCellButtonView alloc] initWithCard:card];
    activityView.tintColor = self.tintColor;

    activityView.userInteractionEnabled = self.userInteractionEnabled;

    [activityView leo_pinToSuperView:self.buttonView];
}

- (void)formatSubviewsWithTintColor:(UIColor *)tintColor {
    self.borderViewAtTopOfBodyView.backgroundColor = tintColor;
}

- (void)setCopyFontAndColor {

    NSDictionary *linkAttributes =
    @{NSForegroundColorAttributeName: [UIColor leo_gray124],
      NSFontAttributeName: [UIFont leo_regular15],
      NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
      NSUnderlineColorAttributeName: [UIColor leo_gray124] };

    self.bodyLabel.linkAttributes = linkAttributes;
    self.bodyLabel.inactiveLinkAttributes = linkAttributes;
    self.bodyLabel.activeLinkAttributes = linkAttributes;
    
    self.bodyLabel.font = [UIFont leo_regular15];
    self.bodyLabel.textColor = [UIColor leo_gray124];
}


@end

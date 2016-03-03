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
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "LEOCardUserView.h"
#import "LEOFeedCellButtonView.h"
#import "UIView+Extensions.h"
#import "LEOPracticeDetailView.h"
#import <NSDate+DateTools.h>
#import "LEOFeedCell+ConfigureForConversationCard.h"
#import "LEOFeedCell+ConfigureForAppointmentCard.h"

@implementation LEOFeedCell (ConfigureForCard)

- (void)configureForCard:(id<LEOCardProtocol>)card {

    self.contentView.backgroundColor = [UIColor leo_grayForMessageBubbles];

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

    [self formatSubviewsWithTintColor:card.tintColor];
    [self setCopyFontAndColor];
}

- (void)formatSubviewsWithTintColor:(UIColor *)tintColor {
    self.borderViewAtTopOfBodyView.backgroundColor = tintColor;
}

- (void)setCopyFontAndColor {

    self.bodyLabel.font = [UIFont leo_standardFont];
    self.bodyLabel.textColor = [UIColor leo_grayStandard];
}


@end

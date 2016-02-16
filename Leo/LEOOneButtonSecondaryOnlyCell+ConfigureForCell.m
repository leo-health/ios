//
//  LEOOneButtonSecondaryOnlyCell+ConfigureForCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOOneButtonSecondaryOnlyCell+ConfigureForCell.h"
#import "LEOCardConversation.h"
#import "LEOCardAppointment.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "LEOSecondaryUserView.h"
#import "Provider.h"

@implementation LEOOneButtonSecondaryOnlyCell (ConfigureForCell)

- (void)configureForCard:(id<LEOCardProtocol>)card {

    self.contentView.backgroundColor = [UIColor leo_grayForMessageBubbles];

    self.iconImageView.image = [card icon];
    self.titleLabel.text = [card title];
    
    [self configureHeaderViewForCard:card];

    self.bodyLabel.text = [card body];
    
    [self.buttonOne setTitle:[card stringRepresentationOfActionsAvailableForState][0] forState:UIControlStateNormal];
    [self.buttonOne removeTarget:nil action:NULL forControlEvents:self.buttonOne.allControlEvents];
    [self.buttonOne addTarget:card.associatedCardObject action:NSSelectorFromString([card actionsAvailableForState][0]) forControlEvents:UIControlEventTouchUpInside];
    
    [self formatSubviewsWithTintColor:card.tintColor];
    [self setCopyFontAndColor];
    
    //FIXME: Should I have access to this method outside of secondaryUserViews
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
    //No configuration at this time
}


- (void)configureHeaderViewForConversationCard:(LEOCardConversation *)card {

    LEOSecondaryUserView *secondaryUserView = [LEOSecondaryUserView new];

    secondaryUserView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.headerView addSubview:secondaryUserView];

    NSDictionary *bindings = NSDictionaryOfVariableBindings(secondaryUserView);

    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[secondaryUserView]|" options:0 metrics:nil views:bindings]];

    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[secondaryUserView]|" options:0 metrics:nil views:bindings]];

    secondaryUserView.provider = (Provider *)card.secondaryUser;
    secondaryUserView.timeStamp = card.timestamp;
    
    //TODO: Once we have this subclass IBDesignable, remove this.
    self.headerView.backgroundColor = [UIColor clearColor];
}


- (void)formatSubviewsWithTintColor:(UIColor *)tintColor {
    
    self.borderViewAtTopOfBodyView.backgroundColor = tintColor;
}

- (void)setCopyFontAndColor {
    
    self.titleLabel.font = [UIFont leo_collapsedCardTitlesFont];
    self.titleLabel.textColor = [UIColor leo_grayForTitlesAndHeadings];
    
    self.bodyLabel.font = [UIFont leo_standardFont];
    self.bodyLabel.textColor = [UIColor leo_grayStandard];
    
    self.buttonOne.titleLabel.font = [UIFont leo_buttonLabelsAndTimeStampsFont];
    [self.buttonOne setTitleColor:[UIColor leo_grayStandard] forState:UIControlStateNormal];
}


@end

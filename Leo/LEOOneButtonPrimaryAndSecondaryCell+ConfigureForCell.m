//
//  LEOOneButtonPrimaryAndSecondaryCell+ConfigureForCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOOneButtonPrimaryAndSecondaryCell+ConfigureForCell.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "LEOSecondaryUserView.h"
#import "LEOCardAppointment.h"
#import "LEOCardConversation.h"
#import "LEOPracticeDetailView.h"

@implementation LEOOneButtonPrimaryAndSecondaryCell (ConfigureForCell)

- (void)configureForCard:(id<LEOCardProtocol>)card {

    self.contentView.backgroundColor = [UIColor leo_grayForMessageBubbles];

    self.iconImageView.image = [card icon];
    self.titleLabel.text = [card title];
    
    self.headerLabel.text = [[card primaryUser].firstName uppercaseString];
    self.bodyLabel.text = [card body];

    [self configureFooterViewForCard:card];

    [self.buttonOne setTitle:[card stringRepresentationOfActionsAvailableForState][0] forState:UIControlStateNormal];
    [self.buttonOne removeTarget:nil action:NULL forControlEvents:self.buttonOne.allControlEvents];
    [self.buttonOne addTarget:card.associatedCardObject action:NSSelectorFromString([card actionsAvailableForState][0]) forControlEvents:UIControlEventTouchUpInside];
    
    [self formatSubviewsWithTintColor:card.tintColor];
    [self setCopyFontAndColor];
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

    LEOPracticeDetailView *practiceDetailView = [LEOPracticeDetailView new];

    practiceDetailView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.bodyFooterView addSubview:practiceDetailView];

    NSDictionary *bindings = NSDictionaryOfVariableBindings(practiceDetailView);

    [self.bodyFooterView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[practiceDetailView]|" options:0 metrics:nil views:bindings]];

    [self.bodyFooterView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[practiceDetailView]|" options:0 metrics:nil views:bindings]];

    practiceDetailView.practice = card.practice;

    //TODO: Once we have this subclass IBDesignable, remove this.
    self.bodyFooterView.backgroundColor = [UIColor clearColor];
}

- (void)configureFooterViewForConversationCard:(LEOCardConversation *)card {

    //No configuration at this time.
}


- (void)formatSubviewsWithTintColor:(UIColor *)tintColor {
    
    self.borderViewAtTopOfBodyView.backgroundColor = tintColor;
}

- (void)setCopyFontAndColor {
    
    self.titleLabel.font = [UIFont leo_collapsedCardTitlesFont];
    self.titleLabel.textColor = [UIColor leo_grayForTitlesAndHeadings];
    
    self.headerLabel.font = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont];
    //self.headerLabel.textColor to be set by card.
    
    self.bodyLabel.font = [UIFont leo_standardFont];
    self.bodyLabel.textColor = [UIColor leo_grayStandard];
    
    self.buttonOne.titleLabel.font = [UIFont leo_buttonLabelsAndTimeStampsFont];
    [self.buttonOne setTitleColor:[UIColor leo_grayStandard] forState:UIControlStateNormal];
}


@end

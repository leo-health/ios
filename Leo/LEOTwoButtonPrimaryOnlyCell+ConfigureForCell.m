//
//  LEOPrimaryOnlyCell+ConfigureForCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/10/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOTwoButtonPrimaryOnlyCell+ConfigureForCell.h"
#import "LEOCard.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "LEOCardAppointment.h"
#import "LEOCardConversation.h"
#import "UIView+Extensions.h"

@implementation LEOTwoButtonPrimaryOnlyCell (ConfigureForCell)


- (void)configureForCard:(id<LEOCardProtocol>)card {

    self.contentView.backgroundColor = [UIColor leo_grayForMessageBubbles];
    self.iconImageView.image = [card icon];
    self.titleLabel.text = [card title];

    [self configureHeaderViewForCard:card];

    self.bodyLabel.text = [card body];
    
    [self.buttonOne setTitle:[card stringRepresentationOfActionsAvailableForState][0] forState:UIControlStateNormal];
    [self.buttonOne removeTarget:nil action:NULL forControlEvents:self.buttonOne.allControlEvents];
    [self.buttonOne addTarget:card.associatedCardObject action:NSSelectorFromString([card actionsAvailableForState][0]) forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttonTwo setTitle:[card stringRepresentationOfActionsAvailableForState][1] forState:UIControlStateNormal];
    [self.buttonTwo removeTarget:nil action:NULL forControlEvents:self.buttonTwo.allControlEvents];
    [self.buttonTwo addTarget:card.associatedCardObject action:NSSelectorFromString([card actionsAvailableForState][1]) forControlEvents:UIControlEventTouchUpInside];
    
    [self formatSubviewsWithTintColor:card.tintColor];
    [self setCopyFontAndColor];
}

- (void)configureHeaderViewForCard:(id<LEOCardProtocol>)card {

    UILabel *nameLabel = [UILabel new];

    [nameLabel leo_pinToSuperView];

    nameLabel.text = [[card primaryUser].firstName uppercaseString];
    nameLabel.textColor = card.tintColor;
    nameLabel.font = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont];
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
    
    self.buttonTwo.titleLabel.font = [UIFont leo_buttonLabelsAndTimeStampsFont];
    [self.buttonTwo setTitleColor:[UIColor leo_grayStandard] forState:UIControlStateNormal];
}


@end

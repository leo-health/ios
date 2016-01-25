//
//  LEOTwoButtonSecondaryOnlyCell+ConfigureForCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOTwoButtonSecondaryOnlyCell+ConfigureForCell.h"
#import "LEOCard.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "LEOSecondaryUserView.h"

@implementation LEOTwoButtonSecondaryOnlyCell (ConfigureForCell)

- (void)configureForCard:(id<LEOCardProtocol>)card {
    
    self.iconImageView.image = [card icon];
    self.titleLabel.text = [card title];
    
    self.secondaryUserView.provider = (Provider *)card.secondaryUser;
    self.secondaryUserView.timeStamp = card.timestamp;
    self.secondaryUserView.cardLayout = CardLayoutTwoButtonSecondaryOnly;
    self.secondaryUserView.backgroundColor = [UIColor clearColor];
    self.bodyLabel.text = [card body];
    
    
    [self.buttonOne setTitle:[card stringRepresentationOfActionsAvailableForState][0] forState:UIControlStateNormal];
    [self.buttonOne removeTarget:nil action:NULL forControlEvents:self.buttonOne.allControlEvents];
    [self.buttonOne addTarget:card.associatedCardObject action:NSSelectorFromString([card actionsAvailableForState][0]) forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttonTwo setTitle:[card stringRepresentationOfActionsAvailableForState][1] forState:UIControlStateNormal];
    
    [self.buttonTwo removeTarget:nil action:NULL forControlEvents:self.buttonTwo.allControlEvents];
    [self.buttonTwo addTarget:card.associatedCardObject action:NSSelectorFromString([card actionsAvailableForState][1]) forControlEvents:UIControlEventTouchUpInside];
    
    [self formatSubviewsWithTintColor:card.tintColor];

    [self setCopyFontAndColor];

    // FixME: is there a better place for this?
    // should separate into both, read, unread methods

    self.bodyView.backgroundColor = [UIColor leo_white];

    if (self.unreadState) {

        [self configureForUnreadCard:card];
    }
    
    //FIXME: Should I have access to this method outside of secondaryUserViews
    [self.secondaryUserView refreshSubviews];
}

- (void)configureForUnreadCard:(id<LEOCardProtocol>)card {

    // TODO: define unread state configuration here

//    self.bodyView.backgroundColor = [UIColor blackColor];
}

- (void)formatSubviewsWithTintColor:(UIColor *)tintColor {
    
    self.borderViewAtTopOfBodyView.backgroundColor = tintColor;
    self.secondaryUserView.cardColor = tintColor;
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

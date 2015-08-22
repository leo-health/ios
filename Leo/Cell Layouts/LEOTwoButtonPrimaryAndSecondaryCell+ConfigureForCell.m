//
//  LEOTwoButtonPrimaryAndSecondaryCell+ConfigureForCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOTwoButtonPrimaryAndSecondaryCell+ConfigureForCell.h"
#import "LEOCard.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "LEOSecondaryUserView.h"

@implementation LEOTwoButtonPrimaryAndSecondaryCell (ConfigureForCell)

- (void)configureForCard:(LEOCard *)card {
    
    self.iconImageView.image = [card icon];
    self.titleLabel.text = [card title];
    
    self.primaryUserLabel.text = [card primaryUser].firstName;

    self.secondaryUserView.provider = card.secondaryUser;
    self.secondaryUserView.timeStamp = card.timestamp;
    self.secondaryUserView.cardColor = card.tintColor;
    self.secondaryUserView.cardLayout = CardLayoutTwoButtonPrimaryAndSecondary;
    self.secondaryUserView.backgroundColor = [UIColor clearColor];
    self.bodyLabel.text = [card body];
    
    
    [self.buttonOne setTitle:[card stringRepresentationOfActionsAvailableForState][0] forState:UIControlStateNormal];
    [self.buttonOne removeTarget:nil action:NULL forControlEvents:self.buttonOne.allControlEvents];
    [self.buttonOne addTarget:card action:NSSelectorFromString([card actionsAvailableForState][0]) forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttonTwo setTitle:[card stringRepresentationOfActionsAvailableForState][1] forState:UIControlStateNormal];
    
    [self.buttonTwo removeTarget:nil action:NULL forControlEvents:self.buttonTwo.allControlEvents];
    [self.buttonTwo addTarget:card action:NSSelectorFromString([card actionsAvailableForState][1]) forControlEvents:UIControlEventTouchUpInside];
    [self formatSubviewsWithTintColor:card.tintColor];
    
    //FIXME: Should I have access to this method outside of secondaryUserViews
    [self.secondaryUserView refreshSubviews];
    
}

- (void)formatSubviewsWithTintColor:(UIColor *)tintColor {
    
    self.titleLabel.font = [UIFont leoTitleFont];
    self.titleLabel.textColor = [UIColor leoGrayTitleText];
    
    self.primaryUserLabel.font = [UIFont leoUserFont];
    self.primaryUserLabel.textColor = tintColor;

    self.bodyLabel.font = [UIFont leoBodyFont];
    self.bodyLabel.textColor = [UIColor leoGrayBodyText];
    
    self.buttonOne.titleLabel.font = [UIFont leoButtonFont];
    [self.buttonOne setTitleColor:[UIColor leoGrayButtonText] forState:UIControlStateNormal];
    
    self.buttonTwo.titleLabel.font = [UIFont leoButtonFont];
    [self.buttonTwo setTitleColor:[UIColor leoGrayButtonText] forState:UIControlStateNormal];
}


@end
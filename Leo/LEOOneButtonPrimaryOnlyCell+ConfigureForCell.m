//
//  LEOOneButtonPrimaryOnlyCell+ConfigureForCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOOneButtonPrimaryOnlyCell+ConfigureForCell.h"
#import "LEOCard.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"

@implementation LEOOneButtonPrimaryOnlyCell (ConfigureForCell)

- (void)configureForCard:(LEOCard *)card {
    self.iconImageView.image = [card icon];
    self.titleLabel.text = [card title];
    
    self.primaryUserLabel.text = [[card primaryUser].firstName uppercaseString];
    
    self.bodyLabel.text = [card body];
    
    
    [self.buttonOne setTitle:[card stringRepresentationOfActionsAvailableForState][0] forState:UIControlStateNormal];
    [self.buttonOne removeTarget:nil action:NULL forControlEvents:self.buttonOne.allControlEvents];
    [self.buttonOne addTarget:card action:NSSelectorFromString([card actionsAvailableForState][0]) forControlEvents:UIControlEventTouchUpInside];
    
    [self formatSubviewsWithTintColor:card.tintColor];
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
}


@end

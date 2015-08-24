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

@implementation LEOTwoButtonPrimaryOnlyCell (ConfigureForCell)


- (void)configureForCard:(LEOCard *)card {
    
    self.iconImageView.image = [card icon];
    self.titleLabel.text = [card title];
    
    self.primaryUserLabel.text = [[card primaryUser].firstName uppercaseString];
    
    self.bodyLabel.text = [card body];
    
    [self.buttonOne setTitle:[card stringRepresentationOfActionsAvailableForState][0] forState:UIControlStateNormal];
    [self.buttonOne removeTarget:nil action:NULL forControlEvents:self.buttonOne.allControlEvents];
    [self.buttonOne addTarget:card action:NSSelectorFromString([card actionsAvailableForState][0]) forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttonTwo setTitle:[card stringRepresentationOfActionsAvailableForState][1] forState:UIControlStateNormal];
    [self.buttonTwo removeTarget:nil action:NULL forControlEvents:self.buttonTwo.allControlEvents];
    [self.buttonTwo addTarget:card action:NSSelectorFromString([card actionsAvailableForState][1]) forControlEvents:UIControlEventTouchUpInside];
    
    [self formatSubviewsWithTintColor:card.tintColor];
    [self setCopyFontAndColor];
}

- (void)formatSubviewsWithTintColor:(UIColor *)tintColor {
    
    self.topBorderView.backgroundColor = tintColor;
    self.primaryUserLabel.textColor = tintColor;
}

- (void)setCopyFontAndColor {
    
    self.titleLabel.font = [UIFont leoTitleFont];
    self.titleLabel.textColor = [UIColor leoGrayTitleText];
    
    self.primaryUserLabel.font = [UIFont leoUserFont];
    
    self.bodyLabel.font = [UIFont leoBodyFont];
    self.bodyLabel.textColor = [UIColor leoGrayBodyText];
    
    self.buttonOne.titleLabel.font = [UIFont leoButtonFont];
    [self.buttonOne setTitleColor:[UIColor leoGrayButtonText] forState:UIControlStateNormal];
    
    self.buttonTwo.titleLabel.font = [UIFont leoButtonFont];
    [self.buttonTwo setTitleColor:[UIColor leoGrayButtonText] forState:UIControlStateNormal];
}


@end

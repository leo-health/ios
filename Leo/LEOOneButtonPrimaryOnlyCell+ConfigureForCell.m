//
//  LEOOneButtonPrimaryOnlyCell+ConfigureForCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOOneButtonPrimaryOnlyCell+ConfigureForCell.h"
#import "LEOCollapsedCard.h"
#import "LEOButtonView.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"

@implementation LEOOneButtonPrimaryOnlyCell (ConfigureForCell)

- (void)configureForCard:(LEOCollapsedCard *)card
{
    self.iconImageView.image = [card icon];
    self.titleLabel.text = [card title];
    self.primaryUserLabel.text = [card primaryUser].firstName;
    self.bodyLabel.text = [card body];
    [self.buttonOne setTitle:[card stringRepresentationOfActionsAvailableForState][0] forState:UIControlStateNormal];
    [self.buttonOne addTarget:card action:NSSelectorFromString([card actionsAvailableForState][0]) forControlEvents:UIControlEventTouchUpInside];
    
      [self formatSubviews];
}

- (void)formatSubviews {
    
    self.titleLabel.font = [UIFont leoTitleBoldFont];
    self.titleLabel.textColor = [UIColor leoWarmHeavyGray];
    
    self.primaryUserLabel.font = [UIFont leoBodyBolderFont];
    self.primaryUserLabel.textColor = [UIColor leoWarmHeavyGray];
    
    self.bodyLabel.font = [UIFont leoBodyBasicFont];
    self.bodyLabel.textColor = [UIColor leoWarmHeavyGray];
    
    self.buttonOne.titleLabel.font = [UIFont leoBodyBolderFont];
    [self.buttonOne setTitleColor:[UIColor leoWarmHeavyGray] forState:UIControlStateNormal];
}

@end

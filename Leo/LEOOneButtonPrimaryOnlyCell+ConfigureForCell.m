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
    [self setCopyFontAndColor];
}

- (void)formatSubviewsWithTintColor:(UIColor *)tintColor {
    
    self.borderViewAtTopOfBodyView.backgroundColor = tintColor;
    self.primaryUserLabel.textColor = tintColor;
}

- (void)setCopyFontAndColor {

    self.titleLabel.font = [UIFont leoCollapsedCardTitlesFont];
    self.titleLabel.textColor = [UIColor leoGrayForTitlesAndHeadings];
    
    self.primaryUserLabel.font = [UIFont leoFieldAndUserLabelsAndSecondaryButtonsFont];
    
    self.bodyLabel.font = [UIFont leoStandardFont];
    self.bodyLabel.textColor = [UIColor leoGrayStandard];
    
    self.buttonOne.titleLabel.font = [UIFont leoButtonLabelsAndTimeStampsFont];
    [self.buttonOne setTitleColor:[UIColor leoGrayStandard] forState:UIControlStateNormal];
}

@end

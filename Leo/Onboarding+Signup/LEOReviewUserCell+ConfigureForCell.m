//
//  LEOReviewUserCell+ConfigureForCell.m
//  Leo
//
//  Created by Zachary Drossman on 10/5/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOReviewUserCell+ConfigureForCell.h"
#import "Guardian.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"

@implementation LEOReviewUserCell (ConfigureForCell)


- (void)configureForGuardian:(Guardian *)guardian {
    
    self.nameLabel.text = guardian.fullName;
    self.insuranceLabel.text = [NSString stringWithFormat:@"%@ %@", guardian.insurancePlan.insurerName, guardian.insurancePlan.name];
    self.phoneNumberLabel.text = guardian.phoneNumber;
    
    [self setCopyFontAndColor];
}

- (void)setCopyFontAndColor {
    
    self.nameLabel.font = [UIFont leo_medium19];
    self.nameLabel.textColor = [UIColor leo_gray124];
    
    self.insuranceLabel.font = [UIFont leo_regular15];
    self.insuranceLabel.textColor = [UIColor leo_gray124];
    
    self.phoneNumberLabel.font = [UIFont leo_regular15];
    self.phoneNumberLabel.textColor = [UIColor leo_gray124];
    
    [self.editButton setTitleColor:[UIColor leo_orangeRed] forState:UIControlStateNormal];
    self.editButton.titleLabel.font = [UIFont leo_bold12];
}

@end

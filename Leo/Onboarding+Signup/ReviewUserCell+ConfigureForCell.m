//
//  ReviewUserCell+ConfigureForCell.m
//  Leo
//
//  Created by Zachary Drossman on 10/5/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "ReviewUserCell+ConfigureForCell.h"
#import "Guardian.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"

@implementation ReviewUserCell (ConfigureForCell)


- (void)configureForGuardian:(Guardian *)guardian {
    
    self.nameLabel.text = guardian.fullName;
    self.insuranceLabel.text = [NSString stringWithFormat:@"%@ %@", guardian.insurancePlan.insurerName, guardian.insurancePlan.name];
    self.phoneNumberLabel.text = guardian.phoneNumber;
    
    [self setCopyFontAndColor];
}

- (void)setCopyFontAndColor {
    
    self.nameLabel.font = [UIFont leoCollapsedCardTitlesFont];
    self.nameLabel.textColor = [UIColor leoGrayStandard];
    
    self.insuranceLabel.font = [UIFont leoStandardFont];
    self.insuranceLabel.textColor = [UIColor leoGrayStandard];
    
    self.phoneNumberLabel.font = [UIFont leoStandardFont];
    self.phoneNumberLabel.textColor = [UIColor leoGrayStandard];
    
    [self.editButton setTitleColor:[UIColor leoOrangeRed] forState:UIControlStateNormal];
    self.editButton.titleLabel.font = [UIFont leoFieldAndUserLabelsAndSecondaryButtonsFont];
}

@end

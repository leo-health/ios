//
//  LEOLoggedOutLoginCell.m
//  Leo
//
//  Created by Adam Fanslau on 1/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOLoggedOutLoginCell.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"

@implementation LEOLoggedOutLoginCell

- (void)awakeFromNib {

    [self.loginButton setTitleColor:[UIColor leo_orangeRed] forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont leo_buttonLabelsAndTimeStampsFont];
}


@end

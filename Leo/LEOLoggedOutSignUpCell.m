//
//  LEOLoggedOutSignUpCell.m
//  Leo
//
//  Created by Adam Fanslau on 1/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOLoggedOutSignUpCell.h"
#import "LEOStyleHelper.h"

@implementation LEOLoggedOutSignUpCell

- (void)awakeFromNib {

    [super awakeFromNib];

    [LEOStyleHelper styleSubmissionButton:self.signUpButton forFeature:FeatureOnboarding];
}

@end

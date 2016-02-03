//
//  LEOLoggedOutSignUpCell.m
//  Leo
//
//  Created by Adam Fanslau on 1/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOLoggedOutSignUpCell.h"
#import "LEOStyleHelper.h"
#import "UIImage+Extensions.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"

@implementation LEOLoggedOutSignUpCell

- (void)awakeFromNib {

    [super awakeFromNib];

    self.swipeArrowsContainerView.hidden = YES;
}

@end

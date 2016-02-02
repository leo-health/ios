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

@interface LEOLoggedOutSignUpCell()

@property (weak, nonatomic) IBOutlet UILabel *labelHaveAnAccountAlready;
@property (weak, nonatomic) IBOutlet UILabel *labelValueProp;

@end

@implementation LEOLoggedOutSignUpCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.labelValueProp.textColor = [UIColor leo_grayForTitlesAndHeadings];
    self.labelValueProp.font = [UIFont leo_valuePropOnboardingFont];
}

@end

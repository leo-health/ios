//
//  LEOPromptViewCell+ConfigureForPatient.m
//  Leo
//
//  Created by Zachary Drossman on 9/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOPromptViewCell+ConfigureForPatient.h"
#import "LEOPromptView.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"

@implementation LEOPromptViewCell (ConfigureForPatient)

- (void)configureForPatient:(Patient *)patient {
    
    self.promptView.textField.text = patient.fullName;
    self.promptView.accessoryImageViewVisible = YES;
    self.promptView.accessoryImage = [UIImage imageNamed:@"Icon-ForwardArrow"];
    [self setCopyFontAndColor];
}

- (void)setCopyFontAndColor {
    
    self.promptView.textField.textColor = [UIColor leoOrangeRed];
    self.promptView.textField.font = [UIFont leoStandardFont];
}

@end

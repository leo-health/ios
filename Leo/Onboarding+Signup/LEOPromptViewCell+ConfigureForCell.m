//
//  LEOPromptViewCell+ConfigureForPatient.m
//  Leo
//
//  Created by Zachary Drossman on 9/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOPromptViewCell+ConfigureForCell.h"
#import "LEOPromptView.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"

@implementation LEOPromptViewCell (ConfigureForPatient)

- (void)configureForPatient:(Patient *)patient {
    
    self.promptView.textField.text = patient.fullName;
    self.promptView.accessoryImageViewVisible = YES;
    self.promptView.tintColor = [UIColor leoOrangeRed];
    self.promptView.accessoryImage = [UIImage imageNamed:@"Icon-ForwardArrow"];
    self.promptView.textField.enabled = NO;
    self.promptView.tapGestureEnabled = NO;
    self.promptView.textField.standardPlaceholder = @"";
    
    [self setPatientCopyFontAndColor];
}

- (void)configureForNewPatient {
    self.promptView.textField.text = @"Add a child";
    self.promptView.accessoryImageViewVisible = YES;
    self.promptView.tintColor = [UIColor leoOrangeRed];
    self.promptView.accessoryImage = [UIImage imageNamed:@"Icon-Add"];
    self.promptView.textField.enabled = NO;
    self.promptView.tapGestureEnabled = NO;
    
    [self setNewPatientCopyFontAndColor];
}

- (void)setPatientCopyFontAndColor {
    
    self.promptView.textField.textColor = [UIColor leoOrangeRed];
    self.promptView.textField.font = [UIFont leoStandardFont];
}

- (void)setNewPatientCopyFontAndColor {
    self.promptView.textField.textColor = [UIColor leoGrayStandard];
    self.promptView.textField.font = [UIFont leoStandardFont];
}

@end

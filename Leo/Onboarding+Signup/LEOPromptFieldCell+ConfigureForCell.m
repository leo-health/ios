//
//  LEOPromptFieldCell+ConfigureForPatient.m
//  Leo
//
//  Created by Zachary Drossman on 9/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOPromptFieldCell+ConfigureForCell.h"
#import "LEOPromptField.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"

@implementation LEOPromptFieldCell (ConfigureForPatient)

- (void)configureForPatient:(Patient *)patient {
    
    self.promptField.textField.text = patient.fullName;
    self.promptField.accessoryImageViewVisible = YES;
    self.promptField.tintColor = [UIColor leo_orangeRed];
    self.promptField.accessoryImage = [UIImage imageNamed:@"Icon-ForwardArrow"];
    self.promptField.textField.enabled = NO;
    self.promptField.tapGestureEnabled = NO;
    self.promptField.textField.standardPlaceholder = @"";
    
    [self setPatientCopyFontAndColor];
}

- (void)configureForNewPatient {
    self.promptField.textField.text = @"Add a child";
    self.promptField.accessoryImageViewVisible = YES;
    self.promptField.tintColor = [UIColor leo_orangeRed];
    self.promptField.accessoryImage = [UIImage imageNamed:@"Icon-Add"];
    self.promptField.textField.enabled = NO;
    self.promptField.tapGestureEnabled = NO;
    self.promptField.textField.standardPlaceholder = @"";

    [self setNewPatientCopyFontAndColor];
}

- (void)setPatientCopyFontAndColor {
    
    self.promptField.textField.textColor = [UIColor leo_orangeRed];
    self.promptField.textField.font = [UIFont leo_standardFont];
}

- (void)setNewPatientCopyFontAndColor {
    self.promptField.textField.textColor = [UIColor leo_grayStandard];
    self.promptField.textField.font = [UIFont leo_standardFont];
}

@end

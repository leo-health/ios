//
//  LEOValidatedFloatLabeledTextView.m
//  Leo
//
//  Created by Zachary Drossman on 12/16/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOValidatedFloatLabeledTextView.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"

@implementation LEOValidatedFloatLabeledTextView

IB_DESIGNABLE
- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];

    if (self) {
        [self localCommonInit];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];

    if (self) {
        [self localCommonInit];
    }

    return self;
}

- (void)localCommonInit {

    self.valid = YES;
    self.placeholder = self.standardPlaceholder;
    self.font = [UIFont leo_regular15];
    self.floatingLabelActiveTextColor = [UIColor leo_grayStandard];
    self.textColor = [UIColor leo_grayStandard];
    self.tintColor = [UIColor leo_orangeRed];
}

- (void)setStandardPlaceholder:(NSString *)standardPlaceholder {

    _standardPlaceholder = standardPlaceholder;
    self.placeholder = standardPlaceholder;
}

-(void)setValid:(BOOL)valid {

    _valid = valid;

    if (valid) {
        self.placeholder = self.standardPlaceholder;
        self.floatingLabelTextColor = [UIColor leo_grayForPlaceholdersAndLines];
        self.floatingLabelActiveTextColor = [UIColor leo_grayForPlaceholdersAndLines];
        [self updatePlaceholderWithColor:[UIColor leo_grayForPlaceholdersAndLines]];

    } else {
        self.placeholder = self.validationPlaceholder;
        self.floatingLabelTextColor = [UIColor redColor];
        self.floatingLabelActiveTextColor = [UIColor redColor];
        [self updatePlaceholderWithColor:[UIColor redColor]];
    }
}

- (void)updatePlaceholderWithColor:(UIColor *)color {

    self.placeholderTextColor = color;
}

@end

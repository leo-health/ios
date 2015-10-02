//
//  LEOValidatedFloatLabeledTextField.m
//  Leo
//
//  Created by Zachary Drossman on 9/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOValidatedFloatLabeledTextField.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"

@implementation LEOValidatedFloatLabeledTextField

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
    self.font = [UIFont leoStandardFont];
    self.floatingLabelActiveTextColor = [UIColor leoGrayStandard];
    self.textColor = [UIColor leoGrayStandard];
    self.tintColor = [UIColor leoOrangeRed];
}

- (void)setStandardPlaceholder:(NSString *)standardPlaceholder {
    
    _standardPlaceholder = standardPlaceholder;
    self.placeholder = standardPlaceholder;
}

-(void)setValid:(BOOL)valid {
    
    _valid = valid;
    
    if (valid) {
        self.placeholder = self.standardPlaceholder;
        self.floatingLabelTextColor = [UIColor leoGrayForPlaceholdersAndLines];
        self.floatingLabelActiveTextColor = [UIColor leoGrayForPlaceholdersAndLines];
        [self updatePlaceholderWithColor:[UIColor leoGrayForPlaceholdersAndLines]];
        
    } else {
        self.placeholder = self.validationPlaceholder;
        self.floatingLabelTextColor = [UIColor redColor];
        self.floatingLabelActiveTextColor = [UIColor redColor];
        [self updatePlaceholderWithColor:[UIColor redColor]];
    }
}

- (void)updatePlaceholderWithColor:(UIColor *)color {
    
    NSMutableAttributedString *mutablePlaceholder = [self.attributedPlaceholder mutableCopy];
    
    [mutablePlaceholder setAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(0,[mutablePlaceholder length])];
    
    self.attributedPlaceholder = mutablePlaceholder;
}


@end

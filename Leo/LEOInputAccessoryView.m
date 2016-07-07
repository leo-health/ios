//
//  LEOInputAccessoryView.m
//  Leo
//
//  Created by Adam Fanslau on 3/2/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOInputAccessoryView.h"
#import "UIFont+LeoFonts.h"
#import "LEOStyleHelper.h"
#import "UIColor+LeoColors.h"

@interface LEOInputAccessoryView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doneButtonTrailingConstraint;

@end

@implementation LEOInputAccessoryView

- (void)awakeFromNib {

    [super awakeFromNib];

    self.doneButton.titleLabel.font = [UIFont leo_bold12];
    self.doneButtonTrailingConstraint.constant = kPaddingHorizontalToolbarButtons;
    [self updateFeatureDependentAttributes];
}

- (void)setFeature:(Feature)feature {

    _feature = feature;
    [self updateFeatureDependentAttributes];
}

- (void)updateFeatureDependentAttributes {

    self.backgroundColor = [LEOStyleHelper backgroundColorForFeature:self.feature];
    [self.doneButton setTitleColor:[LEOStyleHelper headerIconColorForFeature:self.feature] forState:UIControlStateNormal];
}

@end

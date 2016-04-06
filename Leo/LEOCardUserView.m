//
//  LEOCardUserView.m
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOCardUserView.h"
#import "Provider.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "Guardian.h"
#import "Support.h"

@interface LEOCardUserView ()

@property (strong, nonatomic, nonnull, readwrite) User *user;
@property (strong, nonatomic, nonnull, readwrite) UIColor *cardColor;

@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *suffixCredentialLabel;

@property (nonatomic) BOOL constraintsAlreadyUpdated;

@end

@implementation LEOCardUserView


#pragma mark - Initialization

- (nonnull instancetype)initWithUser:(nonnull User *)user cardColor:(UIColor *)cardColor {

    self = [super init];
    if (self) {

        _cardColor = cardColor;
        _user = user;
    }

    return self;
}


#pragma mark - Accessors

- (UILabel *)nameLabel {

    if (!_nameLabel) {

        UILabel *strongLabel = [UILabel new];
        _nameLabel = strongLabel;

        if ([self.user isKindOfClass:[Provider class]] || [self.user isKindOfClass:[Guardian class]]) {
            _nameLabel.text = [[NSString stringWithFormat:@"%@", [self.user fullName]] capitalizedString];
        } else if ([self.user isKindOfClass:[Support class]]) {
            _nameLabel.text = [[NSString stringWithFormat:@"%@", [self.user fullName]] capitalizedString];
        } else {
            _nameLabel.text = [[self.user fullName] capitalizedString];
        }

        _nameLabel.textColor = self.cardColor;
        _nameLabel.font = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont];

        [self addSubview:_nameLabel];
    }

    return _nameLabel;
}

- (UILabel *)suffixCredentialLabel {
    
    if (!_suffixCredentialLabel) {

        UILabel *strongLabel = [UILabel new];
        _suffixCredentialLabel = strongLabel;

        _suffixCredentialLabel.text = @"";

        if ([self.user isMemberOfClass:[Provider class]]) {

            Provider *provider = (Provider *)self.user;

            NSString *credentials = @"";

            for (NSInteger i = 0; i < [provider.credentials count]; i++) {

                if (i != 0) {
                    credentials = [credentials stringByAppendingString:@" "];
                }

                credentials = [credentials  stringByAppendingString:provider.credentials[i]];
            }

            NSString *credentialWithoutPeriods = [provider.credentials[0] stringByReplacingOccurrencesOfString:@"." withString:@""];
            _suffixCredentialLabel.text = credentialWithoutPeriods; //undermines what was done above, but short term solution. see issue #149.
        }

        if ([self.user isMemberOfClass:[Support class]]) {

            Support *support = (Support *)self.user;
            _suffixCredentialLabel.text = support.jobTitle;
        }

        _suffixCredentialLabel.textColor = [UIColor leo_grayStandard];
        _suffixCredentialLabel.font = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont];

        [self addSubview:_suffixCredentialLabel];
    }

    return _suffixCredentialLabel;
}


#pragma mark - Autolayout

- (void)updateConstraints {

    if (!self.constraintsAlreadyUpdated) {

        [self removeConstraints:self.constraints];
        
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.suffixCredentialLabel.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *bindings = NSDictionaryOfVariableBindings(_nameLabel, _suffixCredentialLabel);

        NSArray *horizontalLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_nameLabel]-(3)-[_suffixCredentialLabel]" options:0 metrics:nil views:bindings];

        NSArray *nameLabelVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_nameLabel]|" options:0 metrics:nil views:bindings];

        NSArray *suffixCredentialLabelVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_suffixCredentialLabel]|" options:0 metrics:nil views:bindings];

        [self addConstraints:horizontalLayoutConstraints];
        [self addConstraints:nameLabelVerticalConstraints];
        [self addConstraints:suffixCredentialLabelVerticalConstraints];

        self.constraintsAlreadyUpdated = YES;
    }
    
    [super updateConstraints];
}


@end

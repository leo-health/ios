//
//  LEOSecondaryUserView.m
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOSecondaryUserView.h"
#import <NSDate+DateTools.h>
#import "User.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "LEOConstants.h"

@implementation LEOSecondaryUserView



- (nonnull instancetype)initWithCardType:(NSInteger)cardType user:(nonnull User *)user timestamp:(nonnull NSDate *)timestamp {

    self = [super init];
    if (self) {
        _nameLabel = [[UILabel alloc] init];
        _suffixLabel = [[UILabel alloc] init];
        _dividerLabel = [[UILabel alloc] init];
        _timestampLabel = [[UILabel alloc] init];
        _cardType = cardType;
        
        _nameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName]; //FIXME: Replace with transient property on User class
        _suffixLabel.text = user.title;
        _dividerLabel.text = @"∙";
        
        if (cardType == CardTypeConversation) {
            _timestampLabel.text = timestamp.timeAgoSinceNow;
        } else {
            //FIXME: This only accounts for dates within the past year! And doesn't yet deal with timezones!
            _timestampLabel.text = [timestamp formattedDateWithFormat:@"'MM' 'dd', T'HH':'mm'Z'"];
        }
        
        [self addSubview:_nameLabel];
        [self addSubview:_suffixLabel];
        [self addSubview:_dividerLabel];
        [self addSubview:_timestampLabel];
        
        [self colorView];
        [self typefaceView];
        [self layoutView];
        
        
    }
    return self;
}

- (void)layoutView {
    
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.suffixLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.dividerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.timestampLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self removeConstraints:self.constraints];
    
    UILabel *localNameLabel = self.nameLabel;
    UILabel *localSuffixLabel = self.suffixLabel;
    UILabel *localDividerLabel = self.dividerLabel;
    UILabel *localTimestampLabel = self.timestampLabel;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(localDividerLabel, localNameLabel, localSuffixLabel, localTimestampLabel);
    
    NSArray *horizontalLayoutConstraints;
    if (self.cardType == CardTypeConversation) {
        horizontalLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[localNameLabel]-(4)-[localSuffixLabel]-[localDividerLabel]-[localTimestampLabel]" options:0 metrics:nil views:viewsDictionary];
    }
    else {
        horizontalLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[localTimestampLabel]-[localDividerLabel]-[localNameLabel]-(4)-[localSuffixLabel]" options:0 metrics:nil views:viewsDictionary];
    }
    
    NSArray *nameLabelVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[localNameLabel]|" options:0 metrics:nil views:viewsDictionary];
    
    NSArray *suffixLabelVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[localSuffixLabel]|" options:0 metrics:nil views:viewsDictionary];
    
    NSArray *dividerLabelVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[localDividerLabel]|" options:0 metrics:nil views:viewsDictionary];
    
    NSArray *timestampVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[localTimestampLabel]|" options:0 metrics:nil views:viewsDictionary];

    
    [self addConstraints:horizontalLayoutConstraints];
    [self addConstraints:nameLabelVerticalConstraints];
    [self addConstraints:suffixLabelVerticalConstraints];
    [self addConstraints:dividerLabelVerticalConstraints];
    [self addConstraints:timestampVerticalConstraints];
}

- (void)colorView {
    self.nameLabel.textColor = self.cardTintColor;
    self.suffixLabel.textColor = [UIColor leoWarmHeavyGray];
    self.dividerLabel.textColor = [UIColor leoWarmHeavyGray];
    self.timestampLabel.textColor = [UIColor leoWarmLightGray];
}

- (void)typefaceView {
    self.nameLabel.font = [UIFont leoBodyBolderFont];
    self.suffixLabel.font = [UIFont leoBodyBolderFont];
    self.dividerLabel.font = [UIFont leoBodyBasicFont];
    self.timestampLabel.font = [UIFont leoBodyBasicFont];
}

@end

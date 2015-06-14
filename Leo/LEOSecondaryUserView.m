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

@interface LEOSecondaryUserView ()

@property (weak, nonatomic, nonnull)  UILabel *nameLabel;
@property (weak, nonatomic, nullable) UILabel *suffixLabel;
@property (weak, nonatomic, nullable) UILabel *suffixCredentialLabel;
@property (weak, nonatomic, nullable) UILabel *timestampLabel;
@property (weak, nonatomic, nullable) UILabel *dividerLabel;


@property (strong, nonatomic, nonnull) UIColor *cardTintColor; //FIXME: Likely will remove and associate with User at some stage.


@property (nonatomic) BOOL constraintsAlreadyUpdated;

@end


@implementation LEOSecondaryUserView

-(void)awakeFromNib {
    UILabel *nameLabelStrong = [[UILabel alloc] init];
    _nameLabel = nameLabelStrong;
    UILabel *suffixLabelStrong = [[UILabel alloc] init];
    _suffixLabel = suffixLabelStrong;
    UILabel *suffixCredentialLabel = [[UILabel alloc] init];
    _suffixCredentialLabel = suffixCredentialLabel;
    UILabel *dividerLabelStrong = [[UILabel alloc] init];
    _dividerLabel = dividerLabelStrong;
    UILabel *timestampLabelStrong = [[UILabel alloc] init];
    _timestampLabel = timestampLabelStrong;
    
    [self addSubview:self.nameLabel];
    [self addSubview:self.suffixLabel];
    [self addSubview:self.dividerLabel];
    [self addSubview:self.timestampLabel];
    [self addSubview:self.suffixCredentialLabel];
    
}

- (void)setupSubviews {
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@ %@",self.user.title, self.user.firstName, self.user.lastName]; //FIXME: Replace with transient property on User class
    self.suffixLabel.text = self.user.suffix;
    self.suffixCredentialLabel.text = self.user.credentialSuffix;
    self.dividerLabel.text = @"∙";
    
    if (self.cardLayout == CardLayoutTwoButtonSecondaryOnly) {
        self.timestampLabel.text = self.timeStamp.timeAgoSinceNow;
    } else {
        //FIXME: This only accounts for dates within the past year! And doesn't yet deal with timezones!
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMM dd',' HH':'mm"];
        self.timestampLabel.text = [format stringFromDate:self.timeStamp];
        
    }
    
    [self colorView];
    [self typefaceView];
}

- (nonnull instancetype)initWithCardLayout:(CardLayout)cardLayout user:(nonnull User *)user timestamp:(nonnull NSDate *)timestamp {
    
    self = [super init];
    if (self) {
        
        _cardLayout = cardLayout;
        _user = user;
        _timeStamp = timestamp;
        
    }
    
    return self;
}

- (void)removeSubviews {
    
    [self.nameLabel removeFromSuperview];
    [self.timestampLabel removeFromSuperview];
    [self.suffixCredentialLabel removeFromSuperview];
    [self.nameLabel removeFromSuperview];
    [self.dividerLabel removeFromSuperview];
}

- (void)updateConstraints {
    
    [self setupSubviews];
    
    if (!self.constraintsAlreadyUpdated) {
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.suffixLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.dividerLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.timestampLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.suffixCredentialLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self removeConstraints:self.constraints];
        
        UILabel *localNameLabel = self.nameLabel;
        UILabel *localSuffixLabel = self.suffixLabel;
        UILabel *localDividerLabel = self.dividerLabel;
        UILabel *localTimestampLabel = self.timestampLabel;
        UILabel *localSuffixCredentialLabel = self.suffixCredentialLabel;
        
        NSDictionary *viewsDictionary = @{@"localDividerLabel":localDividerLabel, @"localNameLabel":localNameLabel, @"localTimestampLabel":localTimestampLabel, @"localSuffixCredentialLabel":localSuffixCredentialLabel, @"localSuffixLabel":localSuffixLabel};
        
        NSArray *horizontalLayoutConstraints;
        if (self.cardLayout == CardLayoutTwoButtonSecondaryOnly) {
            horizontalLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[localNameLabel][localSuffixLabel]-(4)-[localSuffixCredentialLabel]-[localDividerLabel]-[localTimestampLabel]" options:0 metrics:nil views:viewsDictionary];
        }
        else {
            horizontalLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[localTimestampLabel]-[localDividerLabel]-[localNameLabel]-[localSuffixLabel]-(4)-[localSuffixCredentialLabel]" options:0 metrics:nil views:viewsDictionary];
        }
        
        NSArray *nameLabelVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[localNameLabel]|" options:0 metrics:nil views:viewsDictionary];
        
        NSArray *suffixLabelVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[localSuffixLabel]" options:0 metrics:nil views:viewsDictionary];
        
        NSArray *dividerLabelVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[localDividerLabel]|" options:0 metrics:nil views:viewsDictionary];
        
        NSArray *timestampVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[localTimestampLabel]|" options:0 metrics:nil views:viewsDictionary];
        
        NSArray *suffixCredentialLabelVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[localSuffixCredentialLabel]|" options:0 metrics:nil views:viewsDictionary];
        
        
        [self addConstraints:horizontalLayoutConstraints];
        [self addConstraints:nameLabelVerticalConstraints];
        [self addConstraints:suffixLabelVerticalConstraints];
        [self addConstraints:suffixCredentialLabelVerticalConstraints];
        [self addConstraints:dividerLabelVerticalConstraints];
        [self addConstraints:timestampVerticalConstraints];
        
        self.constraintsAlreadyUpdated = YES;
    }
    
    [super updateConstraints];
    
}

- (void)colorView {
    self.nameLabel.textColor = self.cardTintColor;
    self.suffixLabel.textColor = [UIColor leoWarmHeavyGray];
    self.dividerLabel.textColor = [UIColor leoWarmHeavyGray];
    self.timestampLabel.textColor = [UIColor leoWarmHeavyGray];
    self.suffixCredentialLabel.textColor = [UIColor leoWarmHeavyGray];
}


- (void)typefaceView {
    self.nameLabel.font = [UIFont leoBodyBolderFont];
    self.suffixLabel.font = [UIFont leoBodyBolderFont];
    self.suffixCredentialLabel.font = [UIFont leoBodyBolderFont];
    self.dividerLabel.font = [UIFont leoBodyBoldFont];
    self.timestampLabel.font = [UIFont leoBodyBasicFont];
}


@end

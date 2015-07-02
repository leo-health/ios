//
//  LEOSecondaryUserView.m
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOSecondaryUserView.h"
#import <NSDate+DateTools.h>
#import "Provider.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "LEOConstants.h"

@interface LEOSecondaryUserView ()

@property (weak, nonatomic, nonnull)  UILabel *nameLabel;
@property (weak, nonatomic, nullable) UILabel *suffixLabel;
@property (weak, nonatomic, nullable) UILabel *suffixCredentialLabel;
@property (weak, nonatomic, nullable) UILabel *timestampLabel;
@property (weak, nonatomic, nullable) UILabel *dividerLabel;

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
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@ %@",self.provider.title, self.provider.firstName, self.provider.lastName]; //FIXME: Replace with transient property on User class
    self.suffixLabel.text = self.provider.suffix;
    self.suffixCredentialLabel.text = self.provider.credential;
    self.dividerLabel.text = @"∙";
    
    if (self.cardLayout == CardLayoutOneButtonSecondaryOnly) {
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

- (nonnull instancetype)initWithCardLayout:(CardLayout)cardLayout user:(nonnull Provider *)provider timestamp:(nonnull NSDate *)timestamp {
    
    self = [super init];
    if (self) {
        
        _cardLayout = cardLayout;
        _provider = provider;
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
        
        //[self removeConstraints:self.constraints];
        
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
            horizontalLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[localTimestampLabel]-[localDividerLabel]-[localNameLabel]-(2)-[localSuffixLabel]-(2)-[localSuffixCredentialLabel]" options:0 metrics:nil views:viewsDictionary];
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
    
    self.nameLabel.textColor = self.cardColor;
    self.suffixLabel.textColor = [UIColor leoGrayBodyText];
    self.dividerLabel.textColor = [UIColor leoGrayBodyText];
    self.timestampLabel.textColor = [UIColor leoGrayBodyText];
    self.suffixCredentialLabel.textColor = [UIColor leoGrayBodyText];
}


- (void)typefaceView {
    
    self.nameLabel.font = [UIFont leoUserFont];
    self.suffixLabel.font = [UIFont leoUserFont];
    self.suffixCredentialLabel.font = [UIFont leoUserFont];
    self.dividerLabel.font = [UIFont leoUserFont];
    self.timestampLabel.font = [UIFont leoButtonFont];
}


@end

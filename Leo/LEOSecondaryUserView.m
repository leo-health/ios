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

@interface LEOSecondaryUserView ()

@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic) UILabel *suffixCredentialLabel;
@property (strong, nonatomic) UILabel *timestampLabel;
@property (strong, nonatomic) UILabel *dividerLabel;

@property (nonatomic) BOOL constraintsAlreadyUpdated;

@end


@implementation LEOSecondaryUserView

-(void)awakeFromNib {
    
    self.nameLabel = [[UILabel alloc] init];
    self.suffixCredentialLabel = [[UILabel alloc] init];
    self.dividerLabel = [[UILabel alloc] init];
    self.timestampLabel = [[UILabel alloc] init];
    
    [self addSubview:self.nameLabel];
    [self addSubview:self.dividerLabel];
    [self addSubview:self.timestampLabel];
    [self addSubview:self.suffixCredentialLabel];
}

- (void)refreshSubviews {
    
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@", [self.provider fullName]];
    
    NSString *credentials = @"";
    
    if ([self.provider isMemberOfClass:[Provider class]]) {
        for (NSInteger i = 0; i < [self.provider.credentials count]; i++) {
            
            if (i != 0) {
                credentials = [credentials stringByAppendingString:@" "];
            }
            
            credentials = [credentials  stringByAppendingString:self.provider.credentials[i]];
        }
        
        NSString *credentialWithoutPeriods = [self.provider.credentials[0] stringByReplacingOccurrencesOfString:@"." withString:@""];
        self.suffixCredentialLabel.text = credentialWithoutPeriods; //undermines what was done above, but short term solution. see issue #149.
    }
    
    self.dividerLabel.text = @"∙";
    
    if (self.cardLayout == CardLayoutOneButtonSecondaryOnly || self.cardLayout == CardLayoutTwoButtonSecondaryOnly) {
        self.timestampLabel.text = self.timeStamp.timeAgoSinceNow;
    } else {
        //FIXME: This only accounts for dates within the past year! And doesn't yet deal with timezones!
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMMM d',' h':'mma"];
        format.AMSymbol = @"am";
        format.PMSymbol = @"pm";
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
    
    [self refreshSubviews];
    
    if (!self.constraintsAlreadyUpdated) {
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.dividerLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.timestampLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.suffixCredentialLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        //[self removeConstraints:self.constraints];
        
        UILabel *localNameLabel = self.nameLabel;
        UILabel *localDividerLabel = self.dividerLabel;
        UILabel *localTimestampLabel = self.timestampLabel;
        UILabel *localSuffixCredentialLabel = self.suffixCredentialLabel;
        
        NSDictionary *viewsDictionary = @{@"localDividerLabel":localDividerLabel, @"localNameLabel":localNameLabel, @"localTimestampLabel":localTimestampLabel, @"localSuffixCredentialLabel":localSuffixCredentialLabel};
        
        NSArray *horizontalLayoutConstraints;
        if (self.cardLayout == CardLayoutTwoButtonSecondaryOnly) {
            horizontalLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[localNameLabel]-(4)-[localSuffixCredentialLabel]-[localDividerLabel]-[localTimestampLabel]" options:0 metrics:nil views:viewsDictionary];
        }
        else {
            horizontalLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[localTimestampLabel]-[localDividerLabel]-[localNameLabel]-(2)-[localSuffixCredentialLabel]" options:0 metrics:nil views:viewsDictionary];
        }
        
        NSArray *nameLabelVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[localNameLabel]|" options:0 metrics:nil views:viewsDictionary];
        
        NSArray *dividerLabelVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[localDividerLabel]|" options:0 metrics:nil views:viewsDictionary];
        
        NSArray *timestampVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[localTimestampLabel]|" options:0 metrics:nil views:viewsDictionary];
        
        NSArray *suffixCredentialLabelVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[localSuffixCredentialLabel]|" options:0 metrics:nil views:viewsDictionary];
        
        
        [self addConstraints:horizontalLayoutConstraints];
        [self addConstraints:nameLabelVerticalConstraints];
        [self addConstraints:suffixCredentialLabelVerticalConstraints];
        [self addConstraints:dividerLabelVerticalConstraints];
        [self addConstraints:timestampVerticalConstraints];
        
        self.constraintsAlreadyUpdated = YES;
    }
    
    [super updateConstraints];
}

- (void)colorView {
    
    self.nameLabel.textColor = self.cardColor;
    self.dividerLabel.textColor = [UIColor leoGrayStandard];
    self.timestampLabel.textColor = [UIColor leoGrayForTimeStamps];
    self.suffixCredentialLabel.textColor = [UIColor leoGrayStandard];
}


- (void)typefaceView {
    
    self.nameLabel.font = [UIFont leoFieldAndUserLabelsAndSecondaryButtonsFont];
    self.suffixCredentialLabel.font = [UIFont leoFieldAndUserLabelsAndSecondaryButtonsFont];
    self.dividerLabel.font = [UIFont leoFieldAndUserLabelsAndSecondaryButtonsFont];
    self.timestampLabel.font = [UIFont leoButtonLabelsAndTimeStampsFont];
}


@end

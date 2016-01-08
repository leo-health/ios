//
//  LEOPHRTVSectionHeaderView.m
//  Leo
//
//  Created by Adam Fanslau on 1/11/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOPHRTVSectionHeaderView.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"

@interface LEOPHRTVSectionHeaderView ()

@property (weak, nonatomic) UIView *separatorLine;
@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end

@implementation LEOPHRTVSectionHeaderView

-(instancetype)init {

    self = [super init];
    if (self) {

        [self commonInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {

        [self commonInit];
    }
    return self;
}

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {

        [self commonInit];
    }
    return self;
}

- (void)commonInit {

    UILabel *strongLabel = [UILabel new];
    strongLabel.font = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont]; // bold 12
    [self.contentView addSubview:strongLabel];
    _titleLabel = strongLabel;

    UIView *strongView = [UIView new];
    strongView.backgroundColor = [UIColor leo_grayStandard];
    [self.contentView addSubview:strongView];
    _separatorLine = strongView;
}

//-(UILabel *)titleLabel {
//    if (!_titleLabel) {
//        UILabel *strongLabel = [UILabel new];
//        strongLabel.font = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont]; // bold 12
//        [self addSubview:strongLabel];
//        _titleLabel = strongLabel;
//    }
//    return _titleLabel;
//}
//
//- (UIView *)separatorLine {
//    if (!_separatorLine) {
//        UIView *strongView = [UIView new];
//        strongView.backgroundColor = [UIColor leo_grayStandard];
//        [self addSubview:strongView];
//        _separatorLine = strongView;
//    }
//    return _separatorLine;
//}

-(void)updateConstraints {

//    [super updateConstraints];

    if (!self.alreadyUpdatedConstraints) {

//        [self removeConstraints:self.constraints];
        [self.contentView removeConstraints:self.contentView.constraints];
//        self.translatesAutoresizingMaskIntoConstraints = NO;
//        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.separatorLine.translatesAutoresizingMaskIntoConstraints = NO;

        NSNumber *spacing = @4;
        NSNumber *margin = @20;
        UIView *_contentView = self.contentView;
        NSDictionary *views = NSDictionaryOfVariableBindings(_titleLabel, _separatorLine, _contentView);
        NSDictionary *metrics = NSDictionaryOfVariableBindings(spacing, margin);

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[_titleLabel]-(spacing)-[_separatorLine(1)]-(margin)-|" options:0 metrics:metrics views:views]];

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[_titleLabel]-(margin)-|" options:0 metrics:metrics views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[_separatorLine]-(margin)-|" options:0 metrics:metrics views:views]];

//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|" options:0 metrics:nil views:views]];
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|" options:0 metrics:nil views:views]];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateConstraints];
}

//-(CGSize)intrinsicContentSize {
//    // shouldnt need this
//    return CGSizeMake(UIViewNoIntrinsicMetric, 100);
//}

@end

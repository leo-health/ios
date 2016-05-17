//
//  LEOPaymentOverviewPriceView.m
//  Leo
//
//  Created by Zachary Drossman on 5/17/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOProductOverviewPriceView.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"

@interface LEOProductOverviewPriceView ()

@property (weak, nonatomic) UILabel *pricingLabel;
@property (weak, nonatomic) UILabel *firstDetailLabel;
@property (weak, nonatomic) UILabel *secondDetailLabel;

@property (nonatomic) BOOL alreadyUpdatedConstraints;

@property (strong, nonatomic) NSNumber *price;
@property (copy, nonatomic) NSAttributedString *firstDetailAttributedString;
@property (copy, nonatomic) NSAttributedString *secondDetailAttributedString;

@end

@implementation LEOProductOverviewPriceView

- (instancetype)initWithPrice:(NSNumber *)price firstDetailAttributedString:(NSAttributedString *)firstDetailAttributedString secondDetailAttributedString:(NSAttributedString *)secondDetailAttributedString {

    self = [super init];

    if (self) {

        _price = price;
        _firstDetailAttributedString = firstDetailAttributedString;
        _secondDetailAttributedString = secondDetailAttributedString;   
    }

    return self;
}

- (instancetype)initWithPrice:(NSNumber *)price firstDetailString:(NSString *)firstDetailString secondDetailString:(NSString *)secondDetailString {

        NSDictionary *defaultAttributes = @{ NSForegroundColorAttributeName : [UIColor leo_orangeRed],
                                                        NSFontAttributeName : [UIFont leo_ultraLight14] };

        NSAttributedString *firstDetailAttributedString = [[NSAttributedString alloc] initWithString:firstDetailString attributes:defaultAttributes];
        NSAttributedString *secondDetailAttributedString = [[NSAttributedString alloc] initWithString:secondDetailString attributes:defaultAttributes];

        return [self initWithPrice:price firstDetailAttributedString:firstDetailAttributedString secondDetailAttributedString:secondDetailAttributedString];
}



- (UILabel *)pricingLabel {

    if (!_pricingLabel) {

        UILabel *strongLabel = [UILabel new];

        _pricingLabel = strongLabel;

        _pricingLabel.text = [NSString stringWithFormat:@"$%@",self.price];
        _pricingLabel.textColor = [UIColor leo_orangeRed];
        _pricingLabel.font = [UIFont leo_ultraLight39];

        [self addSubview:_pricingLabel];
    }

    return _pricingLabel;
}

- (UILabel *)firstDetailLabel {

    if (!_firstDetailLabel) {

        UILabel *strongLabel = [UILabel new];

        _firstDetailLabel = strongLabel;

        _firstDetailLabel.attributedText = self.firstDetailAttributedString;

        [self addSubview:_firstDetailLabel];
    }

    return _firstDetailLabel;
}

- (UILabel *)secondDetailLabel {

    if (!_secondDetailLabel) {

        UILabel *strongLabel = [UILabel new];

        _secondDetailLabel = strongLabel;

        _secondDetailLabel.attributedText = self.secondDetailAttributedString;

        [self addSubview:_secondDetailLabel];
    }
    
    return _secondDetailLabel;
}

- (void)updateConstraints {

    [super updateConstraints];

    if (!self.alreadyUpdatedConstraints) {

        self.pricingLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.firstDetailLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.secondDetailLabel.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *bindings = NSDictionaryOfVariableBindings(_pricingLabel, _firstDetailLabel, _secondDetailLabel);

        NSArray *verticalConstraintsForPricingLabel =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_pricingLabel]|"
                                                options:0
                                                metrics:nil
                                                  views:bindings];

        NSArray *horizontalConstraintsForFirstDetailLabel =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_pricingLabel]-(3)-[_firstDetailLabel]"
                                                options:0
                                                metrics:nil
                                                  views:bindings];

        NSArray *horizontalConstraintsForSecondDetailLabel =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_pricingLabel]-(3)-[_secondDetailLabel]"
                                                options:0
                                                metrics:nil
                                                  views:bindings];

        NSLayoutConstraint *topConstraintForSecondDetailLabel =
        [NSLayoutConstraint constraintWithItem:self.secondDetailLabel
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.pricingLabel
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                      constant:-2.0];

        NSLayoutConstraint *bottomConstraintForFirstDetailLabel =
        [NSLayoutConstraint constraintWithItem:self.firstDetailLabel
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.pricingLabel
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                      constant:-2.0];

        [self addConstraint:topConstraintForSecondDetailLabel];
        [self addConstraint:bottomConstraintForFirstDetailLabel];
        [self addConstraints:verticalConstraintsForPricingLabel];
        [self addConstraints:horizontalConstraintsForFirstDetailLabel];
        [self addConstraints:horizontalConstraintsForSecondDetailLabel];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateConstraints];
}

-(void)layoutSubviews {

    [super layoutSubviews];
}

- (CGSize)intrinsicContentSize {

    CGFloat intrinsicWidth = self.pricingLabel.intrinsicContentSize.width + MAX(self.firstDetailLabel.intrinsicContentSize.width, self.secondDetailLabel.intrinsicContentSize.width);
    CGFloat intrinsicHeight = self.pricingLabel.intrinsicContentSize.height;

    return CGSizeMake(intrinsicWidth, intrinsicHeight);
}

@end

//
//  LEOProductOverviewView.m
//  Leo
//
//  Created by Zachary Drossman on 5/16/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOProductOverviewView.h"

#import "LEOProductOverviewPriceView.h"

#import "UIButton+Extensions.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "LEOStyleHelper.h"
#import "LEOSession.h"

@interface LEOProductOverviewView ()

@property (weak, nonatomic) UILabel *firstFeatureLabel;
@property (weak, nonatomic) UIImageView *firstFeatureImageView;

@property (weak, nonatomic) UILabel *secondFeatureLabel;
@property (weak, nonatomic) UIImageView *secondFeatureImageView;

@property (weak, nonatomic) UILabel *thirdFeatureLabel;
@property (weak, nonatomic) UIImageView *thirdFeatureImageView;

@property (weak, nonatomic) UILabel *fourthFeatureLabel;
@property (weak, nonatomic) UIImageView *fourthFeatureImageView;

@property (weak, nonatomic) UILabel *fifthFeatureLabel;
@property (weak, nonatomic) UIImageView *fifthFeatureImageView;

@property (weak, nonatomic) LEOProductOverviewPriceView *priceView;

@property (weak, nonatomic) UIButton *continueButton;

@property (nonatomic) BOOL alreadyUpdatedConstraints;
@property (nonatomic) void (^continueTappedUpInsideBlock) (void);
@property (nonatomic) Feature feature;

@property (strong, nonatomic) NSNumber *price;

@property (copy, nonatomic) NSAttributedString *firstPriceDetailAttributedString;
@property (copy, nonatomic) NSAttributedString *secondPriceDetailAttributedString;

@end

@implementation LEOProductOverviewView

NSString *const kTextFeatureFirst = @"A personalized care team approach for your family";
NSString *const kTextFeatureSecond = @"Visits that start on time + parents can join via video conference";
NSString *const kTextFeatureThird = @"Mobile messaging, scheduling, and health record access";
NSString *const kTextFeatureFourth = @"Community support + exclusive access to events and classes";
NSString *const kTextFeatureFifth = @"Prescriptions delivered directly\nto your door";

- (instancetype)initWithFeature:(Feature)feature
                          price:(NSNumber *)price
firstPriceDetailAttributedString:(NSAttributedString *)firstPriceDetailAttributedString
secondPriceDetailAttributedString:(NSAttributedString *)secondPriceDetailAttributedString
    continueTappedUpInsideBlock:(void (^) (void))continueTappedUpInsideBlock {

    self = [super init];

    if (self) {

        _price = price;
        _firstPriceDetailAttributedString = firstPriceDetailAttributedString;
        _secondPriceDetailAttributedString = secondPriceDetailAttributedString;

        _feature = feature;
        _continueTappedUpInsideBlock = continueTappedUpInsideBlock;
    }

    return self;
}

- (instancetype)initWithFeature:(Feature)feature
                          price:(NSNumber *)price
         firstPriceDetailString:(NSString *)firstPriceDetailString
        secondPriceDetailString:(NSString *)secondPriceDetailString
    continueTappedUpInsideBlock:(void (^) (void))continueTappedUpInsideBlock {

    NSAttributedString *firstPriceDetailAttributedString = [[NSAttributedString alloc] initWithString:firstPriceDetailString];
    NSAttributedString *secondPriceDetailAttributedString = [[NSAttributedString alloc] initWithString:secondPriceDetailString];

    return [self initWithFeature:feature price:price firstPriceDetailAttributedString:firstPriceDetailAttributedString secondPriceDetailAttributedString:secondPriceDetailAttributedString continueTappedUpInsideBlock:continueTappedUpInsideBlock];
}

- (UILabel *)firstFeatureLabel {

    if (!_firstFeatureLabel) {

        UILabel *strongLabel = [UILabel new];

        _firstFeatureLabel = strongLabel;

        _firstFeatureLabel.text = kTextFeatureFirst;
        _firstFeatureLabel.font = [self fontForLabel];;
        _firstFeatureLabel.textColor = [UIColor leo_grayStandard];
        _firstFeatureLabel.numberOfLines = 0;
        _firstFeatureLabel.lineBreakMode = NSLineBreakByWordWrapping;

        [self addSubview:_firstFeatureLabel];
    }

    return _firstFeatureLabel;
}

- (UIImageView *)firstFeatureImageView {

    if (!_firstFeatureImageView) {

        UIImageView *strongImageView = [UIImageView new];

        _firstFeatureImageView = strongImageView;

        _firstFeatureImageView.image = [UIImage imageNamed:@"Menu-Scheduling"];

        [self addSubview:_firstFeatureImageView];
    }

    return _firstFeatureImageView;
}

- (UILabel *)secondFeatureLabel {

    if (!_secondFeatureLabel) {

        UILabel *strongLabel = [UILabel new];

        _secondFeatureLabel = strongLabel;

        _secondFeatureLabel.text = kTextFeatureSecond;
        _secondFeatureLabel.font = [self fontForLabel];
        _secondFeatureLabel.textColor = [UIColor leo_grayStandard];
        _secondFeatureLabel.numberOfLines = 0;
        _secondFeatureLabel.lineBreakMode = NSLineBreakByWordWrapping;

        [self addSubview:_secondFeatureLabel];
    }

    return _secondFeatureLabel;
}

- (UIFont *)fontForLabel {

    switch ([LEOSession deviceModel]) {

        case DeviceModel4OrLess:
            return [UIFont leo_emergency911Label];

        case DeviceModel5:
            return [UIFont leo_emergency911Label];

        case DeviceModel6:
            return [UIFont leo_standardFont];

        case DeviceModel6Plus:
            return [UIFont leo_standardFont];

        case DeviceModelUnsupported:
            return [UIFont leo_emergency911Label];
    }

}

- (UIImageView *)secondFeatureImageView {

    if (!_secondFeatureImageView) {

        UIImageView *strongImageView = [UIImageView new];

        _secondFeatureImageView = strongImageView;

        _secondFeatureImageView.image = [UIImage imageNamed:@"Menu-Scheduling"];

        [self addSubview:_secondFeatureImageView];
    }
    
    return _secondFeatureImageView;
}

- (UILabel *)thirdFeatureLabel {

    if (!_thirdFeatureLabel) {

        UILabel *strongLabel = [UILabel new];

        _thirdFeatureLabel = strongLabel;

        _thirdFeatureLabel.text = kTextFeatureThird;
        _thirdFeatureLabel.font = [self fontForLabel];
        _thirdFeatureLabel.textColor = [UIColor leo_grayStandard];
        _thirdFeatureLabel.numberOfLines = 0;
        _thirdFeatureLabel.lineBreakMode = NSLineBreakByWordWrapping;


        [self addSubview:_thirdFeatureLabel];
    }

    return _thirdFeatureLabel;
}

- (UIImageView *)thirdFeatureImageView {

    if (!_thirdFeatureImageView) {

        UIImageView *strongImageView = [UIImageView new];

        _thirdFeatureImageView = strongImageView;
        _thirdFeatureImageView.image = [UIImage imageNamed:@"Menu-Scheduling"];

        [self addSubview:_thirdFeatureImageView];
    }
    
    return _thirdFeatureImageView;
}

- (UILabel *)fourthFeatureLabel {

    if (!_fourthFeatureLabel) {

        UILabel *strongLabel = [UILabel new];

        _fourthFeatureLabel = strongLabel;

        _fourthFeatureLabel.text = kTextFeatureFourth;
        _fourthFeatureLabel.font = [self fontForLabel];
        _fourthFeatureLabel.textColor = [UIColor leo_grayStandard];
        _fourthFeatureLabel.numberOfLines = 0;
        _fourthFeatureLabel.lineBreakMode = NSLineBreakByWordWrapping;

        [self addSubview:_fourthFeatureLabel];
    }

    return _fourthFeatureLabel;
}

- (UIImageView *)fourthFeatureImageView {

    if (!_fourthFeatureImageView) {

        UIImageView *strongImageView = [UIImageView new];

        _fourthFeatureImageView = strongImageView;

        _fourthFeatureImageView.image = [UIImage imageNamed:@"Menu-Scheduling"];

        [self addSubview:_fourthFeatureImageView];
    }
    
    return _fourthFeatureImageView;
}

- (UILabel *)fifthFeatureLabel {

    if (!_fifthFeatureLabel) {

        UILabel *strongLabel = [UILabel new];

        _fifthFeatureLabel = strongLabel;

        _fifthFeatureLabel.text = kTextFeatureFifth;
        _fifthFeatureLabel.font = [self fontForLabel];
        _fifthFeatureLabel.textColor = [UIColor leo_grayStandard];
        _fifthFeatureLabel.numberOfLines = 0;
        _fifthFeatureLabel.lineBreakMode = NSLineBreakByWordWrapping;

        [self addSubview:_fifthFeatureLabel];
    }

    return _fifthFeatureLabel;
}

- (UIImageView *)fifthFeatureImageView {

    if (!_fifthFeatureImageView) {

        UIImageView *strongImageView = [UIImageView new];

        _fifthFeatureImageView = strongImageView;

        _fifthFeatureImageView.image = [UIImage imageNamed:@"Menu-Scheduling"];

        [self addSubview:_fifthFeatureImageView];
    }
    
    return _fifthFeatureImageView;
}

- (LEOProductOverviewPriceView *)priceView {

    if (!_priceView) {

        LEOProductOverviewPriceView *strongView = [[LEOProductOverviewPriceView alloc] initWithPrice:self.price
                                                                                   firstDetailAttributedString:self.firstPriceDetailAttributedString
                                                                                  secondDetailAttributedString:self.secondPriceDetailAttributedString];
        _priceView = strongView;

        [self addSubview:_priceView];
    }

    return _priceView;
}

- (UIButton *)continueButton {

    if (!_continueButton) {

        UIButton *strongButton = [UIButton leo_newButtonWithDisabledStyling];

        _continueButton = strongButton;

        [LEOStyleHelper styleButton:_continueButton forFeature:self.feature];
        [_continueButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
        [_continueButton addTarget:self action:@selector(continueTappedUpInside) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_continueButton];
    }

    return _continueButton;
}

- (void)continueTappedUpInside {

    if (self.continueTappedUpInsideBlock) {
        self.continueTappedUpInsideBlock();
    }
}

- (void)updateConstraints {

    [super updateConstraints];

    if (!self.alreadyUpdatedConstraints) {

        self.firstFeatureImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.secondFeatureImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.thirdFeatureImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.fourthFeatureImageView.translatesAutoresizingMaskIntoConstraints = NO;

        self.firstFeatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.secondFeatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.thirdFeatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.fourthFeatureLabel.translatesAutoresizingMaskIntoConstraints = NO;

        self.continueButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.priceView.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *bindings;

        NSNumber *leadingLabelInset = @80;
        NSNumber *trailingLabelInset = @30;

        NSNumber *spaceBetweenFeatures = [self spaceBetweenFeaturesByDevice];

        NSDictionary *metrics = @{@"leadingLabelInset" : leadingLabelInset,
                                  @"trailingLabelInset" : trailingLabelInset,
                                  @"featureSpacer" : spaceBetweenFeatures};

        NSArray *verticalConstraints;
        switch ([LEOSession deviceModel]) {

            case DeviceModel4OrLess:
            case DeviceModelUnsupported:
            case DeviceModel5: {

                bindings = NSDictionaryOfVariableBindings(_firstFeatureLabel,
                                                          _firstFeatureImageView,
                                                          _secondFeatureLabel,
                                                          _secondFeatureImageView,
                                                          _thirdFeatureLabel,
                                                          _thirdFeatureImageView,
                                                          _fourthFeatureLabel,
                                                          _fourthFeatureImageView,
                                                          _priceView,
                                                          _continueButton);
                verticalConstraints =
                [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_firstFeatureLabel]-(featureSpacer)-[_secondFeatureLabel]-(featureSpacer)-[_thirdFeatureLabel]-(featureSpacer)-[_fourthFeatureLabel]-(>=100)-|"
                                                        options:0
                                                        metrics:metrics
                                                          views:bindings];
            }
                break;

            case DeviceModel6:
            case DeviceModel6Plus: {

                self.fifthFeatureImageView.translatesAutoresizingMaskIntoConstraints = NO;
                self.fifthFeatureLabel.translatesAutoresizingMaskIntoConstraints = NO;

                bindings = NSDictionaryOfVariableBindings(_firstFeatureLabel,
                                                          _firstFeatureImageView,
                                                          _secondFeatureLabel,
                                                          _secondFeatureImageView,
                                                          _thirdFeatureLabel,
                                                          _thirdFeatureImageView,
                                                          _fourthFeatureLabel,
                                                          _fourthFeatureImageView,
                                                          _fifthFeatureLabel,
                                                          _fifthFeatureImageView,
                                                          _priceView,
                                                          _continueButton);

                NSArray *horizontalConstraintsForFifthFeatureLabel =
                [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leadingLabelInset)-[_fifthFeatureLabel]-(trailingLabelInset)-|"
                                                        options:0
                                                        metrics:metrics
                                                          views:bindings];


                verticalConstraints =
                [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_firstFeatureLabel]-(featureSpacer)-[_secondFeatureLabel]-(featureSpacer)-[_thirdFeatureLabel]-(featureSpacer)-[_fourthFeatureLabel]-(featureSpacer)-[_fifthFeatureLabel]-(>=100)-|"
                                                        options:0
                                                        metrics:metrics
                                                          views:bindings];

                NSLayoutConstraint *centerXConstraintForFifthFeatureImageView =
                [NSLayoutConstraint constraintWithItem:self.fifthFeatureImageView
                                             attribute:NSLayoutAttributeCenterX
                                             relatedBy:NSLayoutRelationEqual
                                                toItem:self
                                             attribute:NSLayoutAttributeLeading
                                            multiplier:1.0
                                              constant:38];

                NSLayoutConstraint *centerYConstraintForFifthFeature =
                [NSLayoutConstraint constraintWithItem:self.fifthFeatureLabel
                                             attribute:NSLayoutAttributeCenterY
                                             relatedBy:NSLayoutRelationEqual
                                                toItem:self.fifthFeatureImageView
                                             attribute:NSLayoutAttributeCenterY
                                            multiplier:1.0
                                              constant:0];

                [self addConstraint:centerXConstraintForFifthFeatureImageView];
                [self addConstraint:centerYConstraintForFifthFeature];
                [self addConstraints:horizontalConstraintsForFifthFeatureLabel];
            }
                break;
        }


        NSArray *horizontalConstraintsForFirstFeatureLabel =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leadingLabelInset)-[_firstFeatureLabel]-(trailingLabelInset)-|"
                                                options:0
                                                metrics:metrics
                                                  views:bindings];

        NSArray *horizontalConstraintsForSecondFeatureLabel =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leadingLabelInset)-[_secondFeatureLabel]-(trailingLabelInset)-|"
                                                options:0
                                                metrics:metrics
                                                  views:bindings];

        NSArray *horizontalConstraintsForThirdFeatureLabel =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leadingLabelInset)-[_thirdFeatureLabel]-(trailingLabelInset)-|"
                                                options:0
                                                metrics:metrics
                                                  views:bindings];

        NSArray *horizontalConstraintsForFourthFeatureLabel =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leadingLabelInset)-[_fourthFeatureLabel]-(trailingLabelInset)-|"
                                                options:0
                                                metrics:metrics
                                                  views:bindings];

        NSLayoutConstraint *verticalConstraintForFirstFeatureImageView =
        [NSLayoutConstraint constraintWithItem:self.firstFeatureImageView
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.firstFeatureLabel
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                      constant:0];

        NSLayoutConstraint *verticalConstraintForSecondFeatureImageView =
        [NSLayoutConstraint constraintWithItem:self.secondFeatureImageView
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.secondFeatureLabel
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                      constant:0];

        NSLayoutConstraint *verticalConstraintForThirdFeatureImageView =
        [NSLayoutConstraint constraintWithItem:self.thirdFeatureImageView
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.thirdFeatureLabel
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                      constant:0];

        NSLayoutConstraint *verticalConstraintForFourthFeatureImageView =
        [NSLayoutConstraint constraintWithItem:self.fourthFeatureImageView
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.fourthFeatureLabel
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                      constant:0];

        NSLayoutConstraint *centerXConstraintForFirstFeatureImageView =
        [NSLayoutConstraint constraintWithItem:self.firstFeatureImageView
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeLeading
                                    multiplier:1.0
                                      constant:38];

        NSLayoutConstraint *centerXConstraintForSecondFeatureImageView =
        [NSLayoutConstraint constraintWithItem:self.secondFeatureImageView
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeLeading
                                    multiplier:1.0
                                      constant:38];

        NSLayoutConstraint *centerXConstraintForThirdFeatureImageView =
        [NSLayoutConstraint constraintWithItem:self.thirdFeatureImageView
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeLeading
                                    multiplier:1.0
                                      constant:38];

        NSLayoutConstraint *centerXConstraintForFourthFeatureImageView =
        [NSLayoutConstraint constraintWithItem:self.fourthFeatureImageView
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeLeading
                                    multiplier:1.0
                                      constant:38];

        NSLayoutConstraint *centerYConstraintForFirstFeature =
        [NSLayoutConstraint constraintWithItem:self.firstFeatureLabel
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.firstFeatureImageView
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                      constant:0];

        NSLayoutConstraint *centerYConstraintForSecondFeature =
        [NSLayoutConstraint constraintWithItem:self.secondFeatureLabel
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.secondFeatureImageView
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                      constant:0];

        NSLayoutConstraint *centerYConstraintForThirdFeature =
        [NSLayoutConstraint constraintWithItem:self.thirdFeatureLabel
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.thirdFeatureImageView
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                      constant:0];

        NSLayoutConstraint *centerYConstraintForFourthFeature =
        [NSLayoutConstraint constraintWithItem:self.fourthFeatureLabel
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.fourthFeatureImageView
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                      constant:0];

        NSLayoutConstraint *centerXConstraintForPricingView =
        [NSLayoutConstraint constraintWithItem:self.priceView
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeCenterX
                                    multiplier:1.0
                                      constant:0];

        NSArray *verticalConstraintsForPricingView =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_priceView]-(15)-[_continueButton(==54)]-(24)-|"
                                                options:0
                                                metrics:nil
                                                  views:bindings];

        NSArray *horizontalConstraintsForContinueButton =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_continueButton]|"
                                                options:0
                                                metrics:nil
                                                  views:bindings];

        [self addConstraints:verticalConstraintsForPricingView];
        [self addConstraint:centerXConstraintForPricingView];

        [self addConstraints:horizontalConstraintsForFirstFeatureLabel];
        [self addConstraints:horizontalConstraintsForSecondFeatureLabel];
        [self addConstraints:horizontalConstraintsForThirdFeatureLabel];
        [self addConstraints:horizontalConstraintsForFourthFeatureLabel];
        [self addConstraints:horizontalConstraintsForContinueButton];

        [self addConstraint:verticalConstraintForFirstFeatureImageView];
        [self addConstraint:verticalConstraintForSecondFeatureImageView];
        [self addConstraint:verticalConstraintForThirdFeatureImageView];
        [self addConstraint:verticalConstraintForFourthFeatureImageView];

        [self addConstraints:verticalConstraints];

        [self addConstraint:centerYConstraintForFirstFeature];
        [self addConstraint:centerYConstraintForSecondFeature];
        [self addConstraint:centerYConstraintForThirdFeature];
        [self addConstraint:centerYConstraintForFourthFeature];

        [self addConstraint:centerXConstraintForFirstFeatureImageView];
        [self addConstraint:centerXConstraintForSecondFeatureImageView];
        [self addConstraint:centerXConstraintForThirdFeatureImageView];
        [self addConstraint:centerXConstraintForFourthFeatureImageView];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateConstraints];
}

- (NSNumber *)spaceBetweenFeaturesByDevice {

    switch ([LEOSession deviceModel]) {

        case DeviceModel4OrLess:
        case DeviceModel5:
            return @15;

        case DeviceModel6:
            return @20;

        case DeviceModel6Plus:
            return @30;

        case DeviceModelUnsupported:
            return @10;
    }
}


@end

//
//  LEOFeedCellButtonView.m
//  Leo
//
//  Created by Zachary Drossman on 2/17/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOFeedCellButtonView.h"
#import "LEOCardProtocol.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "UIButton+Extensions.h"

@interface LEOFeedCellButtonView ()

@property (nonatomic) CardConfiguration configuration;
@property (weak, nonatomic) UIButton *leadingButton;
@property (weak, nonatomic) UIButton *trailingButton;
@property (nonatomic) BOOL alreadyUpdatedConstraints;
@property (nonatomic) BOOL enabled;

@end


@implementation LEOFeedCellButtonView

static NSInteger const kInset = 8;
static NSInteger const kButtonHeight = 44;
static NSInteger const kLineThickness = 1;

#pragma mark - Initialization
//TODO: Come back to this and instead of passing the whole card, consider just passing relevant elements. This is a shortcut that I'm only taking for time obviously and that's not ideal.
- (instancetype)initWithCard:(id<LEOCardProtocol>)card {

    self = [super init];

    if (self) {
        _card = card;
    }

    return self;
}

-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {

    [super setUserInteractionEnabled:userInteractionEnabled];

    switch (self.card.configuration) {

        case CardConfigurationTwoButtonHeaderAndFooter:
        case CardConfigurationTwoButtonFooterOnly:
        case CardConfigurationTwoButtonHeaderOnly: {

            self.leadingButton.enabled = userInteractionEnabled;
            self.trailingButton.enabled = userInteractionEnabled;
        }

            break;

        case CardConfigurationOneButtonHeaderAndFooter:
        case CardConfigurationOneButtonFooterOnly:
        case CardConfigurationOneButtonHeaderOnly: {

            self.leadingButton.enabled = userInteractionEnabled;
        }
            break;

        case CardConfigurationUndefined:
            self.leadingButton.enabled = userInteractionEnabled;
    }
}

#pragma mark - Accessors

- (UIButton *)leadingButton {
    
        if (!_leadingButton) {
            
        UIButton *strongButton = [UIButton leo_newButtonWithDisabledStyling];
        _leadingButton = strongButton;

        [_leadingButton setTitle:[self.card stringRepresentationOfActionsAvailableForState][0] forState:UIControlStateNormal];
        [_leadingButton setTitleColor:self.card.tintColor forState:UIControlStateNormal];
        _leadingButton.titleLabel.font = [UIFont leo_buttonLabelsAndTimeStampsFont];

        [_leadingButton addTarget:self.card.associatedCardObject action:NSSelectorFromString([self.card actionsAvailableForState][0]) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_leadingButton];
    }

    return _leadingButton;
}

- (UIButton *)trailingButton {

    if (!_trailingButton) {

        UIButton *strongButton = [UIButton leo_newButtonWithDisabledStyling];
        _trailingButton = strongButton;

        [_trailingButton setTitle:[self.card stringRepresentationOfActionsAvailableForState][1] forState:UIControlStateNormal];
        [_trailingButton setTitleColor:self.card.tintColor forState:UIControlStateNormal];
        _trailingButton.titleLabel.font = [UIFont leo_buttonLabelsAndTimeStampsFont];

        [_trailingButton addTarget:self.card.associatedCardObject action:NSSelectorFromString([self.card actionsAvailableForState][1]) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_trailingButton];
    }

    return _trailingButton;
}


#pragma mark - Autolayout

- (void)updateConstraints {

    if (!self.alreadyUpdatedConstraints) {

        UIView *split = [UIView new];
        split.backgroundColor = [UIColor leo_grayForTimeStamps];
        [self addSubview:split];
        split.translatesAutoresizingMaskIntoConstraints = NO;

        UIView *breaker = [UIView new];
        breaker.backgroundColor = [UIColor leo_grayForTimeStamps];
        [self addSubview:breaker];
        breaker.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *metrics = @{@"lineThickness":@(kLineThickness), @"buttonHeight":@(kButtonHeight), @"splitInset": @(kInset)};

        switch (self.card.configuration) {

            case CardConfigurationTwoButtonHeaderAndFooter:
            case CardConfigurationTwoButtonFooterOnly:
            case CardConfigurationTwoButtonHeaderOnly: {

                [self removeConstraints:self.constraints];

                self.leadingButton.translatesAutoresizingMaskIntoConstraints = NO;
                self.trailingButton.translatesAutoresizingMaskIntoConstraints = NO;

                NSDictionary *bindings = NSDictionaryOfVariableBindings(_leadingButton, _trailingButton, split, breaker);

                NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_leadingButton(==_trailingButton)][split(lineThickness)][_trailingButton]|" options:0 metrics:metrics views:bindings];

                NSArray *verticalConstraintForSplitView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(splitInset)-[split]-(splitInset)-|" options:0 metrics:metrics views:bindings];

                NSArray *verticalConstraintForLeadingButton = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[breaker(lineThickness)][_leadingButton(buttonHeight)]|" options:0 metrics:metrics views:bindings];

                NSArray *verticalConstraintForTrailingButton = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[breaker(lineThickness)][_trailingButton(==44)]|" options:0 metrics:metrics views:bindings];

                NSArray *horizontalConstraintsForBreaker = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[breaker]|" options:0 metrics:metrics views:bindings];

                [self addConstraints:horizontalConstraints];
                [self addConstraints:verticalConstraintForLeadingButton];
                [self addConstraints:verticalConstraintForTrailingButton];
                [self addConstraints:verticalConstraintForSplitView];
                [self addConstraints:horizontalConstraintsForBreaker];
            }
                break;

            case CardConfigurationOneButtonHeaderAndFooter:
            case CardConfigurationOneButtonFooterOnly:
            case CardConfigurationOneButtonHeaderOnly: {

                [self removeConstraints:self.constraints];
                self.leadingButton.translatesAutoresizingMaskIntoConstraints = NO;

                NSDictionary *bindings = NSDictionaryOfVariableBindings(_leadingButton, breaker);

                NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_leadingButton]|" options:0 metrics:nil views:bindings];

                NSArray *verticalConstraintForLeadingButton = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[breaker(lineThickness)][_leadingButton]|" options:0 metrics:nil views:bindings];

                NSArray *horizontalConstraintsForBreaker = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[breaker]|" options:0 metrics:metrics views:bindings];

                [self addConstraints:horizontalConstraints];
                [self addConstraints:verticalConstraintForLeadingButton];
                [self addConstraints:horizontalConstraintsForBreaker];
            }
                break;
                
            case CardConfigurationUndefined:
                break;
        }
        
        self.alreadyUpdatedConstraints = YES;
    }
    
    [super updateConstraints];
}


@end

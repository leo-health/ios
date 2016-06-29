//
//  LEOChartTimeFrameView.m
//  Leo
//
//  Created by Zachary Drossman on 6/27/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOChartTimeFrameView.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "UIImage+Extensions.h"
@interface LEOChartTimeFrameView ()

@property (nonatomic) TimeFrameBlock timeFrameBlock;
@property (nonatomic) CGFloat ageOfChild;

@property (weak, nonatomic) UIButton *allTimeFramesButton;
@property (weak, nonatomic) UIButton *zeroToTwoTimeFrameButton;
@property (weak, nonatomic) UIButton *twoToFiveYearsTimeFrameButton;
@property (weak, nonatomic) UIButton *fivePlusTimeFrameButton;

@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end

@implementation LEOChartTimeFrameView

- (instancetype)initWithAgeOfChild:(CGFloat)ageOfChild
              timeFrameActionBlock:(TimeFrameBlock)timeFrameBlock {

    self = [super init];

    if (self) {

        _ageOfChild = ageOfChild;
        _timeFrameBlock = timeFrameBlock;
    }

    return self;
}

- (void)updateStateOfButton:(UIButton *)button withMinAge:(CGFloat)minAge {

    if (self.ageOfChild > minAge) {
        [self enableButton:button];
    } else {
        [self disableButton:button];
    }
}

- (void)disableButton:(UIButton *)button {

    button.enabled = NO;
    button.layer.borderColor = [UIColor leo_grayStandard].CGColor;
}

- (void)enableButton:(UIButton *)button {

    button.enabled = YES;
    button.layer.borderColor = [UIColor leo_orangeRed].CGColor;
}

- (UIButton *)allTimeFramesButton {

    if (!_allTimeFramesButton) {

        UIButton *strongButton = [UIButton buttonWithType:UIButtonTypeCustom];

        _allTimeFramesButton = strongButton;

        _allTimeFramesButton.selected = YES;

        [self formatTimeFrameButton:_allTimeFramesButton
                              title:@"ALL"
                           selector:@selector(allTimeFramesTouchedUpInside)
                             minAge:0];

        [self addSubview:_allTimeFramesButton];
    }

    return _allTimeFramesButton;
}

- (UIButton *)zeroToTwoTimeFrameButton {

    if (!_zeroToTwoTimeFrameButton) {

        UIButton *strongButton = [UIButton buttonWithType:UIButtonTypeCustom];

        _zeroToTwoTimeFrameButton = strongButton;

        [_zeroToTwoTimeFrameButton setTitle:@"0-2 YEARS"
                                   forState:UIControlStateNormal];

        [self formatTimeFrameButton:_zeroToTwoTimeFrameButton
                              title:@"0-2 YEARS"
                           selector:@selector(zeroToTwoTimeFrameTouchedUpInside)
                             minAge:0];


        [self addSubview:_zeroToTwoTimeFrameButton];
    }
    
    return _zeroToTwoTimeFrameButton;
}

- (UIButton *)twoToFiveYearsTimeFrameButton {

    if (!_twoToFiveYearsTimeFrameButton) {

        UIButton *strongButton = [UIButton buttonWithType:UIButtonTypeCustom];

        _twoToFiveYearsTimeFrameButton = strongButton;

        [_twoToFiveYearsTimeFrameButton setTitle:@"2-5 YEARS"
                                        forState:UIControlStateNormal];

        [self formatTimeFrameButton:_twoToFiveYearsTimeFrameButton
                              title:@"2-5 YEARS"
                           selector:@selector(twoToFiveTimeFrameTouchedUpInside)
                             minAge:2];


        [self addSubview:_twoToFiveYearsTimeFrameButton];
    }

    return _twoToFiveYearsTimeFrameButton;
}

- (UIButton *)fivePlusTimeFrameButton {

    if (!_fivePlusTimeFrameButton) {

        UIButton *strongButton = [UIButton buttonWithType:UIButtonTypeCustom];

        _fivePlusTimeFrameButton = strongButton;

        [_fivePlusTimeFrameButton setTitle:@"5-12 YEARS"
                                  forState:UIControlStateNormal];

        [self formatTimeFrameButton:_fivePlusTimeFrameButton
                              title:@"5-12 YEARS"
                           selector:@selector(fivePlusTimeFrameTouchedUpInside)
                             minAge:5];

        [self addSubview:_fivePlusTimeFrameButton];
    }

    return _fivePlusTimeFrameButton;
}

- (void)formatTimeFrameButton:(UIButton *)button title:(NSString *)title selector:(SEL)selector minAge:(CGFloat)minAge {


    [button setTitleColor:[UIColor leo_orangeRed]
                 forState:UIControlStateNormal];

    [button setTitleColor:[UIColor leo_white]
                 forState:UIControlStateSelected];

    [button setTitleColor:[UIColor leo_grayStandard]
                 forState:UIControlStateDisabled];

    UIImage *selectedBackgroundImage = [UIImage leo_imageWithColor:[UIColor leo_orangeRed]];
    UIImage *normalBackgroundImage = [UIImage leo_imageWithColor:[UIColor leo_white]];

    [button setBackgroundImage:normalBackgroundImage
                      forState:UIControlStateNormal];
    [button setBackgroundImage:normalBackgroundImage
                      forState:UIControlStateDisabled];
    [button setBackgroundImage:selectedBackgroundImage
                      forState:UIControlStateSelected];

    button.titleLabel.font = [UIFont leo_emergency911Label];

    button.contentEdgeInsets = UIEdgeInsetsMake(3, 0, 3, 0);

    button.layer.cornerRadius = 3;
    button.layer.masksToBounds = YES;
    button.layer.borderColor = [UIColor leo_orangeRed].CGColor;
    button.layer.borderWidth = 1;

    [self updateStateOfButton:button withMinAge:minAge];

    [button setTitle:title
            forState:UIControlStateNormal];

    [button addTarget:self
               action:selector
     forControlEvents:UIControlEventTouchUpInside];
}

- (void)allTimeFramesTouchedUpInside {

    [self deselectAllButtons];

    self.selectedAgeRange = LEOAgeRangeAll;

    [self.allTimeFramesButton setSelected:YES];

    if (self.timeFrameBlock) {
        self.timeFrameBlock(0,12);
    }
}

- (void)zeroToTwoTimeFrameTouchedUpInside {

    [self deselectAllButtons];

    self.selectedAgeRange = LEOAgeRangeZeroToTwo;

    [self.zeroToTwoTimeFrameButton setSelected:YES];

    if (self.timeFrameBlock) {
        self.timeFrameBlock(0,2);
    }
}

- (void)twoToFiveTimeFrameTouchedUpInside {

    [self deselectAllButtons];

    self.selectedAgeRange = LEOAgeRangeTwoToFive;

    [self.twoToFiveYearsTimeFrameButton setSelected:YES];

    if (self.timeFrameBlock) {
        self.timeFrameBlock(2,5);
    }
}

- (void)fivePlusTimeFrameTouchedUpInside {

    [self deselectAllButtons];

    self.selectedAgeRange = LEOAgeRangeFivePlus;

    [self.fivePlusTimeFrameButton setSelected:YES];

    if (self.timeFrameBlock) {
        self.timeFrameBlock(5, 12);
    }
}

- (void)deselectAllButtons {

    self.allTimeFramesButton.selected = NO;
    self.zeroToTwoTimeFrameButton.selected = NO;
    self.twoToFiveYearsTimeFrameButton.selected = NO;
    self.fivePlusTimeFrameButton.selected = NO;
}

- (void)updateConstraints {

    if (!self.alreadyUpdatedConstraints) {

        self.allTimeFramesButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.zeroToTwoTimeFrameButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.twoToFiveYearsTimeFrameButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.fivePlusTimeFrameButton.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *bindings =
        NSDictionaryOfVariableBindings(_allTimeFramesButton,
                                       _zeroToTwoTimeFrameButton,
                                       _twoToFiveYearsTimeFrameButton,
                                       _fivePlusTimeFrameButton);

        NSDictionary *metrics = @{@"vSpacer" : @4};

        NSArray *verticalConstraintsForAllTimeFramesButton = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(vSpacer)-[_allTimeFramesButton]-(vSpacer)-|"
                                                                                                     options:0
                                                                                                     metrics:metrics
                                                                                                       views:bindings];

        NSArray *verticalConstraintsForZeroToTwoTimeFrameButton = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(vSpacer)-[_zeroToTwoTimeFrameButton]-(vSpacer)-|"
                                                                                                          options:0
                                                                                                          metrics:metrics
                                                                                                            views:bindings];

        NSArray *verticalConstraintsForTwoToFiveYearsTimeFrameButton = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(vSpacer)-[_twoToFiveYearsTimeFrameButton]-(vSpacer)-|"
                                                                                                               options:0
                                                                                                               metrics:metrics
                                                                                                                 views:bindings];

        NSArray *verticalConstraintsForFivePlusTimeFrameButton = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(vSpacer)-[_fivePlusTimeFrameButton]-(vSpacer)-|"
                                                                                                         options:0
                                                                                                         metrics:metrics
                                                                                                           views:bindings];

        NSArray *horizontalConstraintsForTimeFrameButtons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_allTimeFramesButton]-[_zeroToTwoTimeFrameButton(_allTimeFramesButton)]-[_twoToFiveYearsTimeFrameButton(_allTimeFramesButton)]-[_fivePlusTimeFrameButton(_allTimeFramesButton)]-|"
                                                                                                    options:0
                                                                                                    metrics:nil
                                                                                                      views:bindings];

        [self addConstraints:verticalConstraintsForAllTimeFramesButton];
        [self addConstraints:verticalConstraintsForZeroToTwoTimeFrameButton];
        [self addConstraints:verticalConstraintsForTwoToFiveYearsTimeFrameButton];
        [self addConstraints:verticalConstraintsForFivePlusTimeFrameButton];
        [self addConstraints:horizontalConstraintsForTimeFrameButtons];
        
        
        self.alreadyUpdatedConstraints = YES;
    }

    [super updateConstraints];
}


@end

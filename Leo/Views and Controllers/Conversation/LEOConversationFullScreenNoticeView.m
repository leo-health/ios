//
//  LEOConversationFullScreenNoticeView.m
//  Leo
//
//  Created by Zachary Drossman on 4/21/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOConversationFullScreenNoticeView.h"

#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "LEOStyleHelper.h"

@interface LEOConversationFullScreenNoticeView()

@property (strong, nonatomic) NSAttributedString *attributedHeaderText;
@property (strong, nonatomic) NSAttributedString *attributedBodyText;
@property (strong, nonatomic) NSAttributedString *attributedText;

@property (weak, nonatomic) UILabel *noticeLabel;

@property (weak, nonatomic) UIButton *buttonOne;
@property (weak, nonatomic) UIButton *buttonTwo;
@property (weak, nonatomic) UIButton *buttonDismiss;

@property (copy, nonatomic) void (^buttonOneTouchedUpInsideBlock)(void);
@property (copy, nonatomic) void (^buttonTwoTouchedUpInsideBlock)(void);
@property (copy, nonatomic) void (^dismissButtonTouchedUpInsideBlock)(void);

@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end

@implementation LEOConversationFullScreenNoticeView

- (instancetype)initWithAttributedHeaderText:(NSAttributedString *)attributedHeaderText
                          attributedbodyText:(NSAttributedString *)attributedBodyText
               buttonOneTouchedUpInsideBlock:(void (^) (void))buttonOneTouchedUpInsideBlock
               buttonTwoTouchedUpInsideBlock:(void (^) (void))buttonTwoTouchedUpInsideBlock
           dismissButtonTouchedUpInsideBlock:(void (^) (void))dismissButtonTouchedUpInsideBlock {

    self = [super init];

    if (self) {

        _attributedHeaderText = attributedHeaderText;
        _attributedBodyText = attributedBodyText;

        _buttonOneTouchedUpInsideBlock = buttonOneTouchedUpInsideBlock;
        _buttonTwoTouchedUpInsideBlock = buttonTwoTouchedUpInsideBlock;
        _dismissButtonTouchedUpInsideBlock = dismissButtonTouchedUpInsideBlock;

        self.backgroundColor = [UIColor leo_lightBlue];

        [self concatenateAttributedHeaderText:_attributedHeaderText attributedBodyText:_attributedBodyText];
    }

    return self;
}

-(instancetype)initWithHeaderText:(NSString *)headerText
                         bodyText:(NSString *)bodyText
    buttonOneTouchedUpInsideBlock:(void (^)(void))buttonOneTouchedUpInsideBlock
    buttonTwoTouchedUpInsideBlock:(void (^)(void))buttonTwoTouchedUpInsideBlock
dismissButtonTouchedUpInsideBlock:(void (^)(void))dismissButtonTouchedUpInsideBlock {

    NSAttributedString *attributedHeaderString = [[NSAttributedString alloc] initWithString:headerText attributes:[self fullScreenNoticeHeaderTextAttributes]];
    NSAttributedString *attributedBodyString = [[NSAttributedString alloc] initWithString:bodyText attributes:[self fullScreenNoticeBodyTextAttributes]];

    return [self initWithAttributedHeaderText:attributedHeaderString attributedbodyText:attributedBodyString buttonOneTouchedUpInsideBlock:buttonOneTouchedUpInsideBlock buttonTwoTouchedUpInsideBlock:buttonTwoTouchedUpInsideBlock dismissButtonTouchedUpInsideBlock:dismissButtonTouchedUpInsideBlock];
}

- (void)concatenateAttributedHeaderText:(NSAttributedString *)attributedHeaderText
                attributedBodyText:(NSAttributedString *)attributedBodyText {

    NSMutableAttributedString *attributedText = [NSMutableAttributedString new];

    NSAttributedString *spacer = [[NSAttributedString alloc] initWithString:@" "];
    [attributedText appendAttributedString:self.attributedHeaderText];

    if (self.attributedHeaderText) {
        [attributedText appendAttributedString:spacer];
    }

    [attributedText appendAttributedString:self.attributedBodyText];

    self.attributedText = attributedText;
}

- (UILabel *)noticeLabel {

    if (!_noticeLabel) {

        UILabel *strongLabel = [UILabel new];

        _noticeLabel = strongLabel;
        _noticeLabel.numberOfLines = 0;
        _noticeLabel.lineBreakMode = NSLineBreakByWordWrapping;

        [self addSubview:_noticeLabel];
    }

    return _noticeLabel;
}

- (UIButton *)buttonOne {

    if (!_buttonOne) {

        UIButton *strongButton = [UIButton buttonWithType:UIButtonTypeCustom];

        _buttonOne = strongButton;

        [_buttonOne setTitle:[@"Leave A Message" uppercaseString]
                    forState:UIControlStateNormal];

        [_buttonOne addTarget:self
                       action:@selector(buttonOneTouchedUpInside)
             forControlEvents:UIControlEventTouchUpInside];

        [_buttonOne setTitleColor:[UIColor leo_blue] forState:UIControlStateNormal];

        _buttonOne.titleLabel.font = [UIFont leo_appointmentSlotsAndDateFields];
        _buttonOne.layer.borderWidth = 1.0;
        _buttonOne.layer.borderColor = [UIColor leo_blue].CGColor;

        [LEOStyleHelper roundCornersForView:_buttonOne withCornerRadius:kCornerRadius];

        _buttonOne.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);

        [self addSubview:_buttonOne];
    }

    return _buttonOne;
}

- (UIButton *)buttonTwo {

    if (!_buttonTwo) {

        UIButton *strongButton = [UIButton buttonWithType:UIButtonTypeCustom];

        _buttonTwo = strongButton;

        [_buttonTwo setTitle:[@"Call Us" uppercaseString]
                    forState:UIControlStateNormal];

        [_buttonTwo addTarget:self
                       action:@selector(buttonTwoTouchedUpInside)
             forControlEvents:UIControlEventTouchUpInside];

        [_buttonTwo setTitleColor:[UIColor leo_blue] forState:UIControlStateNormal];

        _buttonTwo.titleLabel.font = [UIFont leo_appointmentSlotsAndDateFields];
        _buttonTwo.layer.borderWidth = 1.0;
        _buttonTwo.layer.borderColor = [UIColor leo_blue].CGColor;

        [LEOStyleHelper roundCornersForView:_buttonTwo withCornerRadius:kCornerRadius];

        _buttonTwo.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);

        [self addSubview:_buttonTwo];
    }
    
    return _buttonTwo;
}

- (UIButton *)buttonDismiss {

    if (!_buttonDismiss) {

        UIButton *strongButton = [UIButton buttonWithType:UIButtonTypeCustom];

        _buttonDismiss = strongButton;

        [_buttonDismiss setImage:[UIImage imageNamed:@"Icon-Cancel"]
                        forState:UIControlStateNormal];

        [_buttonDismiss addTarget:self
                           action:@selector(dismissButtonTouchedUpInside)
                 forControlEvents:UIControlEventTouchUpInside];

        _buttonDismiss.tintColor = [UIColor leo_blue];

        [self addSubview:_buttonDismiss];
    }

    return _buttonDismiss;
}

- (NSDictionary *)fullScreenNoticeHeaderTextAttributes {
    return @{ NSForegroundColorAttributeName : [UIColor leo_blue], NSFontAttributeName : [UIFont leo_fullScreenNoticeHeader] };
}

- (NSDictionary *)fullScreenNoticeBodyTextAttributes {
    return @{ NSForegroundColorAttributeName : [UIColor leo_blue], NSFontAttributeName : [UIFont leo_fullScreenNoticeBody] };
}

-(void)setAttributedHeaderText:(NSAttributedString *)attributedHeaderText {

    _attributedHeaderText = attributedHeaderText;
    [self concatenateAttributedHeaderText:attributedHeaderText attributedBodyText:self.attributedBodyText];
}

-(void)setAttributedBodyText:(NSAttributedString *)attributedBodyText {

    _attributedBodyText = attributedBodyText;
    [self concatenateAttributedHeaderText:self.attributedHeaderText attributedBodyText:attributedBodyText];
}

-(void)setAttributedText:(NSAttributedString *)attributedText {

    _attributedText = attributedText;
    self.noticeLabel.attributedText = attributedText;
}

- (void)updateConstraints {

    [super updateConstraints];

    if (!self.alreadyUpdatedConstraints) {

        [self removeConstraints:self.constraints];

        self.noticeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.buttonOne.translatesAutoresizingMaskIntoConstraints = NO;
        self.buttonTwo.translatesAutoresizingMaskIntoConstraints = NO;
        self.buttonDismiss.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *bindings = NSDictionaryOfVariableBindings(_noticeLabel, _buttonOne, _buttonTwo, _buttonDismiss);

        NSNumber *margin = @45;

        NSDictionary *metrics = NSDictionaryOfVariableBindings(margin);

        NSArray *horizontalConstraintsForNoticeLabel =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[_noticeLabel]-(margin)-|"
                                                options:0
                                                metrics:metrics
                                                  views:bindings];

        NSLayoutConstraint *centerConstraintForButtonOne =
        [NSLayoutConstraint constraintWithItem:self.buttonOne
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeCenterX
                                    multiplier:1.0
                                      constant:0];

        NSLayoutConstraint *centerConstraintForButtonTwo =
        [NSLayoutConstraint constraintWithItem:self.buttonTwo
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeCenterX
                                    multiplier:1.0
                                      constant:0];

        NSLayoutConstraint *centerConstraintForNoticeLabel =
        [NSLayoutConstraint constraintWithItem:self.noticeLabel
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                      constant:0];

        NSArray *verticalConstraintsForButtonTwo =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_buttonOne]-[_buttonTwo]-(margin)-|"
                                                options:0
                                                metrics:metrics
                                                  views:bindings];

        NSArray *horizontalConstraintsForDismissButton = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_buttonDismiss]-|" options:0 metrics:nil views:bindings];

        NSArray *verticalConstraintsForDismissButton = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_buttonDismiss]" options:0 metrics:nil views:bindings];

        [self addConstraints:horizontalConstraintsForNoticeLabel];
        [self addConstraint:centerConstraintForNoticeLabel];

        [self addConstraint:centerConstraintForButtonOne];
        [self addConstraint:centerConstraintForButtonTwo];

        [self addConstraints:verticalConstraintsForButtonTwo];

        [self addConstraints:horizontalConstraintsForDismissButton];
        [self addConstraints:verticalConstraintsForDismissButton];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateConstraints];
}

- (void)buttonOneTouchedUpInside {
    
    if (self.buttonOneTouchedUpInsideBlock) {
        self.buttonOneTouchedUpInsideBlock();
    }
}

- (void)buttonTwoTouchedUpInside {

    if (self.buttonTwoTouchedUpInsideBlock) {
        self.buttonTwoTouchedUpInsideBlock();
    }
}

- (void)dismissButtonTouchedUpInside {

    if (self.dismissButtonTouchedUpInsideBlock) {
        self.dismissButtonTouchedUpInsideBlock();
    }
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}



@end

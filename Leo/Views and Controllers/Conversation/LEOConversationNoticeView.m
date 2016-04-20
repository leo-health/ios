//
//  LEOConversationHeaderView.m
//  Leo
//
//  Created by Zachary Drossman on 4/20/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOConversationNoticeView.h"

#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "Notice.h"

@interface LEOConversationNoticeView()

@property (strong, nonatomic) Notice *notice;

@property (copy, nonatomic) NSAttributedString *attributedHeaderText;
@property (copy, nonatomic) NSAttributedString *attributedBodyText;
@property (copy, nonatomic) NSAttributedString *attributedText;
@property (strong, nonatomic) UIImage *noticeButtonImage;
@property (copy, nonatomic) NSString *noticeButtonText;
@property (copy, nonatomic) void (^noticeButtonTappedUpInsideBlock)(void);

@property (weak, nonatomic) UIButton *noticeButton;
@property (weak, nonatomic) UILabel *noticeLabel;

@end

@implementation LEOConversationNoticeView

- (instancetype)initWithNotice:(Notice *)notice noticeButtonText:(NSString *)noticeButtonText noticeButtonImage:(UIImage *)noticeButtonImage noticeButtonTappedUpInsideBlock:(void (^) (void))noticeButtonTappedUpInsideBlock {

    self = [super init];

    if (self) {

        _notice = notice;
        _noticeButtonText = noticeButtonText;
        _noticeButtonImage = noticeButtonImage;
        _noticeButtonTappedUpInsideBlock = noticeButtonTappedUpInsideBlock;

        [self updateNotice:_notice];

        self.backgroundColor = [UIColor leo_lightBlue];
    }

    return self;
}

- (instancetype)initWithAttributedHeaderText:(NSAttributedString *)attributedHeaderText attributedBodyText:(NSAttributedString *)attributedBodyText noticeButtonText:(NSString *)noticeButtonText noticeButtonImage:(UIImage *)noticeButtonImage noticeButtonTappedUpInsideBlock:(void (^) (void))noticeButtonTappedUpInsideBlock {

    self = [super init];

    if (self) {

        _attributedHeaderText = attributedHeaderText;
        _attributedBodyText = attributedBodyText;
        _noticeButtonText = noticeButtonText;
        _noticeButtonImage = noticeButtonImage;
        _noticeButtonTappedUpInsideBlock = noticeButtonTappedUpInsideBlock;

        [self concatenateAttributedHeaderText:_attributedHeaderText attributedBodyText:_attributedBodyText];

        self.backgroundColor = [UIColor leo_lightBlue];
    }

    return self;
}

- (instancetype)initWithHeaderText:(NSString *)headerText bodyText:(NSString *)bodyText noticeButtonText:(NSString *)noticeButtonText noticeButtonImage:(UIImage *)noticeButtonImage noticeButtonTappedUpInsideBlock:(void (^)(void))noticeButtonTappedUpInsideBlock {

    NSAttributedString *attributedHeaderText = [[NSAttributedString alloc] initWithString:headerText attributes:[self defaultHeaderTextAttributes]];
    NSAttributedString *attributedBodyText = [[NSAttributedString alloc] initWithString:bodyText attributes:[self defaultBodyTextAttributes]];

    return [self initWithAttributedHeaderText:attributedHeaderText attributedBodyText:attributedBodyText noticeButtonText:noticeButtonText noticeButtonImage:noticeButtonImage noticeButtonTappedUpInsideBlock:noticeButtonTappedUpInsideBlock];
}

- (UIButton *)noticeButton {

    if (!_noticeButton) {

        UIButton *strongButton = [UIButton buttonWithType:UIButtonTypeCustom];

        _noticeButton = strongButton;

        [_noticeButton setTitle:self.noticeButtonText forState:UIControlStateNormal];
        [_noticeButton setImage:self.noticeButtonImage forState:UIControlStateNormal]; //Image will override text if provided;

        [_noticeButton addTarget:self action:@selector(noticeButtonTappedUpInside) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_noticeButton];
    }

    return _noticeButton;
}

- (void)updateNotice:(Notice *)notice {

    _notice = notice;

    __block BOOL headerAttributes;

    [_notice.attributedHeaderText enumerateAttributesInRange:NSMakeRange(0, _notice.attributedHeaderText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {

        headerAttributes = attrs.count > 0 ? YES : NO;
    }];

    __block BOOL bodyAttributes;

    [_notice.attributedBodyText enumerateAttributesInRange:NSMakeRange(0, _notice.attributedBodyText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {

        bodyAttributes = attrs.count > 0 ? YES : NO;
    }];

    if (!headerAttributes) {
        notice.attributedHeaderText = [[NSAttributedString alloc] initWithString:notice.attributedHeaderText.string attributes:[self defaultHeaderTextAttributes]];
    }

    if (!bodyAttributes) {
        notice.attributedBodyText = [[NSAttributedString alloc] initWithString:notice.attributedBodyText.string attributes:[self defaultBodyTextAttributes]];
    }

    [self updateAttributedHeaderText:notice.attributedHeaderText attributedBodyText:notice.attributedBodyText];
}

- (void)updateAttributedHeaderText:(NSAttributedString *)attributedHeaderText attributedBodyText:(NSAttributedString *)attributedBodyText {

    [self updateAttributedHeaderText:attributedHeaderText];
    [self updateAttributedBodyText:attributedBodyText];
}

- (void)updateAttributedHeaderText:(NSAttributedString *)attributedHeaderText {
    self.attributedHeaderText = attributedHeaderText;
}

- (void)updateAttributedBodyText:(NSAttributedString *)attributedBodyText {
    self.attributedBodyText = attributedBodyText;
}

-(void)updateHeaderText:(NSString *)headerText {
    self.attributedHeaderText = [[NSAttributedString alloc] initWithString:headerText];
}

- (void)updateBodyText:(NSString *)bodyText {
    self.attributedBodyText = [[NSAttributedString alloc] initWithString:bodyText];
}

-(void)updateHeaderText:(NSString *)headerText bodyText:(NSString *)bodyText {

    [self updateHeaderText:headerText];
    [self updateBodyText:bodyText];
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

    [self.noticeLabel sizeToFit]; //Still necessary?

    [self setNeedsUpdateConstraints];
}

- (NSDictionary *)defaultHeaderTextAttributes {
    return @{
             NSForegroundColorAttributeName : [UIColor leo_blue],
             NSFontAttributeName : [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont]

             };
}

- (NSDictionary *)defaultBodyTextAttributes {
    return @{ NSForegroundColorAttributeName : [UIColor leo_blue], NSFontAttributeName : [UIFont leo_emergency911Label] };
}

- (void)concatenateAttributedHeaderText:(NSAttributedString *)attributedHeaderText
                     attributedBodyText:(NSAttributedString *)attributedBodyText {

    NSMutableAttributedString *attributedText = [NSMutableAttributedString new];

    [attributedText appendAttributedString:attributedHeaderText];

    if (attributedHeaderText) {
        NSAttributedString *spacer = [[NSAttributedString alloc] initWithString:@" "];
        [attributedText appendAttributedString:spacer];
    }

    if (attributedBodyText) {
        [attributedText appendAttributedString:attributedBodyText];
    }

    self.attributedText = attributedText;
}

- (UILabel *)noticeLabel {

    if (!_noticeLabel) {

        UILabel *strongLabel = [UILabel new];

        _noticeLabel = strongLabel;
        _noticeLabel.numberOfLines = 0;
        _noticeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _noticeLabel.textAlignment = NSTextAlignmentCenter;

        [self addSubview:_noticeLabel];
    }

    return _noticeLabel;
}

- (void)updateConstraints {

    [super updateConstraints];

    self.noticeLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self removeConstraints:self.constraints];

    NSDictionary *bindings;
    NSArray *horizontalConstraints;

    if (self.notice.actionAvailable) {

        self.noticeButton.translatesAutoresizingMaskIntoConstraints = NO;

        bindings = NSDictionaryOfVariableBindings(_noticeLabel, _noticeButton);

        horizontalConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(18)-[_noticeLabel]-(10)-[_noticeButton(==30)]-(18)-|"
                                                options:0
                                                metrics:nil
                                                  views:bindings];

        NSArray *verticalConstraintsForNoticeButton =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=10)-[_noticeButton]-(>=10)-|"
                                                options:0
                                                metrics:nil
                                                  views:bindings];

        NSLayoutConstraint *heightConstraintForNoticeButton =
        [NSLayoutConstraint constraintWithItem:_noticeButton
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1.0
                                      constant:40.0];

        NSLayoutConstraint *centerYConstraintForNoticeButton =
        [NSLayoutConstraint constraintWithItem:_noticeButton
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:_noticeLabel
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                      constant:0];

        [self addConstraint:centerYConstraintForNoticeButton];
        [self addConstraint:heightConstraintForNoticeButton];
        [self addConstraints:verticalConstraintsForNoticeButton];

    } else {

        bindings = NSDictionaryOfVariableBindings(_noticeLabel);

        horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(18)-[_noticeLabel]-(18)-|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:bindings];
    }

    NSArray *verticalConstraintsForNoticeLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[_noticeLabel]-(10)-|" options:0 metrics:nil views:bindings];

    [self addConstraints:horizontalConstraints];
    [self addConstraints:verticalConstraintsForNoticeLabel];

    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

+(BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)noticeButtonTappedUpInside {

    if (self.noticeButtonTappedUpInsideBlock) {
        self.noticeButtonTappedUpInsideBlock();
    }
}

@end

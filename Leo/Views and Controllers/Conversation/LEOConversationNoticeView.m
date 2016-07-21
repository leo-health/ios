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
@property (copy, nonatomic) NSAttributedString *attributedText;

@property (strong, nonatomic) UIImage *noticeButtonImage;
@property (copy, nonatomic) NSString *noticeButtonText;
@property (copy, nonatomic) void (^noticeButtonTappedUpInsideBlock)(void);

@property (weak, nonatomic) UIButton *noticeButton;
@property (weak, nonatomic) UILabel *noticeLabel;

@end

@implementation LEOConversationNoticeView

- (instancetype)initWithNotice:(Notice *)notice
              noticeButtonText:(NSString *)noticeButtonText
             noticeButtonImage:(UIImage *)noticeButtonImage
noticeButtonTappedUpInsideBlock:(void (^) (void))noticeButtonTappedUpInsideBlock {

    self = [super init];

    if (self) {

        _notice = notice;
        _noticeButtonText = noticeButtonText;
        _noticeButtonImage = noticeButtonImage;
        _noticeButtonTappedUpInsideBlock = noticeButtonTappedUpInsideBlock;

        self.backgroundColor = [UIColor leo_lightBlue];
    }

    return self;
}

- (NSAttributedString *)buildAttributedHeader {

    return [self attributedStringWithString:self.notice.headerText
                                 attributes:self.notice.headerAttributes
                          defaultAttributes:[self defaultHeaderTextAttributes]];
}

- (NSAttributedString *)buildAttributedBody {

    return [self attributedStringWithString:self.notice.bodyText
                                 attributes:self.notice.bodyAttributes
                          defaultAttributes:[self defaultBodyTextAttributes]];
}

- (NSAttributedString *)attributedStringWithString:(NSString *)string attributes:(NSDictionary *)attributes defaultAttributes:(NSDictionary *)defaultAttributes {

    if (!string) {
        return nil;
    }

    NSDictionary *_attributes = attributes;

    if (!_attributes) {
        _attributes = defaultAttributes;
    }

    if (!_attributes) {
        return [[NSAttributedString alloc] initWithString:string];
    }

    return [[NSAttributedString alloc] initWithString:string attributes:_attributes];
}

- (NSAttributedString *)attributedText {

    if (!_attributedText) {

        NSAttributedString *attributedHeaderText = [self buildAttributedHeader];
        NSAttributedString *attributedBodyText = [self buildAttributedBody];
        NSMutableAttributedString *attributedText = [NSMutableAttributedString new];
        [attributedText appendAttributedString:attributedHeaderText];

        if (attributedBodyText) {

            NSAttributedString *spacer = [[NSAttributedString alloc] initWithString:@" "];
            [attributedText appendAttributedString:spacer];
            [attributedText appendAttributedString:attributedBodyText];
        }

        _attributedText = [attributedText copy];
    }
    return _attributedText;
}

- (UILabel *)noticeLabel {

    if (!_noticeLabel) {

        UILabel *strongLabel = [UILabel new];

        _noticeLabel = strongLabel;
        _noticeLabel.attributedText = self.attributedText;
        _noticeLabel.numberOfLines = 0;
        _noticeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _noticeLabel.textAlignment = NSTextAlignmentCenter;

        [self addSubview:_noticeLabel];
    }

    return _noticeLabel;
}

- (NSDictionary *)defaultBodyTextAttributes {

    return @{ NSForegroundColorAttributeName : [UIColor leo_blue],
              NSFontAttributeName : [UIFont leo_regular12]
              };
}

- (NSDictionary *)defaultHeaderTextAttributes {

    return @{ NSForegroundColorAttributeName : [UIColor leo_blue],
              NSFontAttributeName : [UIFont leo_bold12]
             };
}

- (UIButton *)noticeButton {

    if (!_noticeButton) {

        UIButton *strongButton = [UIButton buttonWithType:UIButtonTypeCustom];

        _noticeButton = strongButton;

        [_noticeButton setTitle:self.noticeButtonText
                       forState:UIControlStateNormal];

        [_noticeButton setImage:self.noticeButtonImage
                       forState:UIControlStateNormal]; //Image will override text if provided;

        [_noticeButton addTarget:self action:@selector(noticeButtonTappedUpInside)
                forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_noticeButton];
    }
    
    return _noticeButton;
}

- (void)noticeButtonTappedUpInside {

    if (self.noticeButtonTappedUpInsideBlock) {
        self.noticeButtonTappedUpInsideBlock();
    }
}

- (void)updateConstraints {

    [super updateConstraints];

    self.noticeLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self removeConstraints:self.constraints];

    NSDictionary *bindings;
    NSArray *horizontalConstraints;

    NSNumber *outerMargin = @18;
    NSNumber *innerMargin = @10;
    NSNumber *buttonWidth = @30;
    NSNumber *buttonHeight = @40;

    NSDictionary *metrics = NSDictionaryOfVariableBindings(outerMargin, innerMargin, buttonWidth);

    if (self.notice.actionAvailable) {

        self.noticeButton.translatesAutoresizingMaskIntoConstraints = NO;

        bindings = NSDictionaryOfVariableBindings(_noticeLabel, _noticeButton);


        horizontalConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(outerMargin)-[_noticeLabel]-(innerMargin)-[_noticeButton(==buttonWidth)]-(outerMargin)-|"
                                                options:0
                                                metrics:metrics
                                                  views:bindings];

        NSArray *verticalConstraintsForNoticeButton =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=innerMargin)-[_noticeButton]-(>=innerMargin)-|"
                                                options:0
                                                metrics:metrics
                                                  views:bindings];

        NSLayoutConstraint *heightConstraintForNoticeButton =
        [NSLayoutConstraint constraintWithItem:_noticeButton
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1.0
                                      constant:[buttonHeight integerValue]];

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

        horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(outerMargin)-[_noticeLabel]-(outerMargin)-|"
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:bindings];
    }

    NSArray *verticalConstraintsForNoticeLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(innerMargin)-[_noticeLabel]-(innerMargin)-|" options:0 metrics:metrics views:bindings];

    [self addConstraints:horizontalConstraints];
    [self addConstraints:verticalConstraintsForNoticeLabel];

    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (CGSize)intrinsicContentSize {

    CGFloat intrinsicHeight = 20 + CGRectGetHeight(self.noticeLabel.frame);
    return CGSizeMake(UIViewNoIntrinsicMetric, intrinsicHeight);
}

@end

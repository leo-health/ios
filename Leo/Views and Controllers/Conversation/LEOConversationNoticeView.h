//
//  LEOConversationHeaderView.h
//  Leo
//
//  Created by Zachary Drossman on 4/20/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

@class Notice;

#import <UIKit/UIKit.h>

@interface LEOConversationNoticeView : UIView

- (instancetype)initWithNotice:(Notice *)notice noticeButtonText:(NSString *)noticeButtonText noticeButtonImage:(UIImage *)noticeButtonImage noticeButtonTappedUpInsideBlock:(void (^) (void))noticeButtonTappedUpInsideBlock;

- (void)updateNotice:(Notice *)notice;

- (instancetype)initWithAttributedHeaderText:(NSAttributedString *)attributedHeaderText attributedBodyText:(NSAttributedString *)attributedBodyText noticeButtonText:(NSString *)noticeButtonText noticeButtonImage:(UIImage *)noticeButtonImage noticeButtonTappedUpInsideBlock:(void (^) (void))noticeButtonTappedUpInsideBlock;

- (instancetype)initWithHeaderText:(NSString *)headerText bodyText:(NSString *)bodyText noticeButtonText:(NSString *)noticeButtonText noticeButtonImage:(UIImage *)noticeButtonImage noticeButtonTappedUpInsideBlock:(void (^) (void))noticeButtonTappedUpInsideBlock;

- (void)updateAttributedHeaderText:(NSAttributedString *)attributedHeaderText attributedBodyText:(NSAttributedString *)attributedBodyText;
- (void)updateAttributedHeaderText:(NSAttributedString *)attributedHeaderText;
- (void)updateAttributedBodyText:(NSAttributedString *)attributedBodyText;

- (void)updateHeaderText:(NSString *)headerText bodyText:(NSString *)bodyText;
- (void)updateHeaderText:(NSString *)headerText;
- (void)updateBodyText:(NSString *)bodyText;
@end

//
//  LEOConversationFullScreenNoticeView.h
//  Leo
//
//  Created by Zachary Drossman on 4/21/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEOConversationFullScreenNoticeView : UIView

- (instancetype)initWithAttributedHeaderText:(NSAttributedString *)attributedHeaderText
                          attributedBodyText:(NSAttributedString *)attributedBodyText
               buttonOneTouchedUpInsideBlock:(void (^) (void))buttonOneTouchedUpInsideBlock
               buttonTwoTouchedUpInsideBlock:(void (^) (void))buttonTwoTouchedUpInsideBlock
           dismissButtonTouchedUpInsideBlock:(void (^) (void))dismissButtonTouchedUpInsideBlock;

- (instancetype)initWithHeaderText:(NSString *)headerText
                          bodyText:(NSString *)bodyText
               buttonOneTouchedUpInsideBlock:(void (^) (void))buttonOneTouchedUpInsideBlock
               buttonTwoTouchedUpInsideBlock:(void (^) (void))buttonTwoTouchedUpInsideBlock
           dismissButtonTouchedUpInsideBlock:(void (^) (void))dismissButtonTouchedUpInsideBlock;

- (void)updateAttributedHeaderText:(NSAttributedString *)attributedHeaderText
                attributedBodyText:(NSAttributedString *)attributedBodyText;
- (void)updateAttributedHeaderText:(NSAttributedString *)attributedHeaderText;
- (void)updateAttributedBodyText:(NSAttributedString *)attributedBodyText;

- (void)updateHeaderText:(NSString *)headerText bodyText:(NSString *)bodyText;
- (void)updateHeaderText:(NSString *)headerText;
- (void)updateBodyText:(NSString *)bodyText;

@end

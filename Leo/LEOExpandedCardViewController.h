//
//  LEOExpandedContainerViewController.h
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/3/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardActivityProtocol.h"

@protocol ExpandedCardDataSource <NSObject>
NS_ASSUME_NONNULL_BEGIN

- (UIView *)setupBodyView;

NS_ASSUME_NONNULL_END
@end


@class LEOCard;

@interface LEOExpandedCardViewController : UIViewController <UIScrollViewDelegate>
NS_ASSUME_NONNULL_BEGIN

@property (weak, nonatomic) id<ExpandedCardDataSource>dataSource;

@property (strong, nonatomic) LEOCard *card;
@property (strong, nonatomic) NSString *expandedFullTitle;
@property (strong, nonatomic) UIView *bodyView;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIButton *button;

- (void)toggleButtonValidated:(BOOL)validated;

NS_ASSUME_NONNULL_END
@end

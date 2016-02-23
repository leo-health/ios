//
//  LEOFeedNavigationHeaderView.h
//  Leo
//
//  Created by Zachary Drossman on 2/23/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LEONavigatorDelegate <NSObject>

- (void)tappedBookAppointment;
- (void)tappedMessageUs;

@end

@interface LEOFeedNavigationHeaderView : UIView

@property (strong, nonatomic) UIButton *bookAppointmentButton;
@property (strong, nonatomic) UIButton *messageUsButton;

@property (weak, nonatomic) id<LEONavigatorDelegate>delegate;

@end

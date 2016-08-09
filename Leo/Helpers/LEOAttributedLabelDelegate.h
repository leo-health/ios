//
//  LEOAttributedLabelDelegate.h
//  Leo
//
//  Created by Zachary Drossman on 8/9/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOFeedCell.h"
#import <EventKitUI/EventKitUI.h>

typedef EKEvent *(^CreateEventBlock)(EKEventStore *eventStore, NSDate *startDate);

@interface LEOAttributedLabelDelegate : NSObject <LEOFeedCellDelegate, EKEventEditViewDelegate>

- (instancetype)initWithViewController:(UIViewController *)viewController setupEventBlock:(CreateEventBlock)createEventBlock;

@end

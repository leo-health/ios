//
//  LEOCalendarViewController.h
//  LEO
//
//  Created by Zachary Drossman on 7/28/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateCollectionController.h" //TODO: Separate out protocol so not importing the whole thing in .h file?
#import "SingleSelectionProtocol.h"
#import "TimeCollectionController.h"

@class LEOAPIOperation;
@class Appointment;

@interface LEOCalendarViewController : UIViewController <DateCollectionProtocol, TimeCollectionProtocol>
NS_ASSUME_NONNULL_BEGIN

@property (strong, nonatomic) Appointment *appointment;
@property (strong, nonatomic) LEOAPIOperation *requestOperation;
@property (weak, nonatomic) id<SingleSelectionProtocol>delegate;

NS_ASSUME_NONNULL_END
@end


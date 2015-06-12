//
//  CardActivityDelegate.h
//  Leo
//
//  Created by Zachary Drossman on 6/10/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LEOCard;
@class Appointment;

@protocol CardActivityProtocol <NSObject>

- (void) didTapButtonOneOnCard:(LEOCard*)card withAssociatedObject:(id)appointment;
- (void) didTapButtonTwoOnCard;
- (void) didUpdateObjectStateForCard:(LEOCard *)card;

@end

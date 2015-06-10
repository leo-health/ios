//
//  CardActivityDelegate.h
//  Leo
//
//  Created by Zachary Drossman on 6/10/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LEOCollapsedCard;
@class Appointment;

@protocol CardActivityProtocol <NSObject>

- (void) didTapButtonOneOnCard:(LEOCollapsedCard*)card withAssociatedObject:(id)appointment;
- (void) didTapButtonTwoOnCard;
- (void) didUpdateObjectStateForCard:(LEOCollapsedCard *)card;

@end

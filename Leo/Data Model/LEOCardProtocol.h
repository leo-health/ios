//
//  LEOCardProtocol.h
//  Leo
//
//  Created by Zachary Drossman on 12/18/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

// Changes here require changes in [LEOCard cardTypes] method, which defines the string representation of these types
// FIXME: is there a better way?
typedef NS_ENUM(NSUInteger, CardType) {

    CardTypeUndefined = 0,
    CardTypeAppointment = 1,
    CardTypeConversation = 2,
    CardTypePayment = 3,
    CardTypeForm = 4,
    CardTypeVisitSummary = 5,
    CardTypeCustom = 6,
};

@protocol LEOCardProtocol <NSObject>

@required

@property (nonatomic, retain) id associatedCardObject;
@property (nonatomic, retain) id activityDelegate;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

- (UIImage *)icon;
- (UIColor *)tintColor;
- (NSString *)title;
- (NSString *)body;
- (CardLayout)layout;
- (NSArray *)stringRepresentationOfActionsAvailableForState;
- (NSDate *)timestamp;
- (NSArray *)actionsAvailableForState;
//- (void)returnToPriorState;

@optional
- (nullable User *)secondaryUser;
- (nullable User *)primaryUser;

NS_ASSUME_NONNULL_END
@end

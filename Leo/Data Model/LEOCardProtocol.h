//
//  LEOCardProtocol.h
//  Leo
//
//  Created by Zachary Drossman on 12/18/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Practice.h"

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

typedef NS_ENUM(NSUInteger, CardConfiguration) {

    CardConfigurationUndefined = 0,
    CardConfigurationTwoButtonHeaderAndFooter = 1,
    CardConfigurationTwoButtonHeaderOnly = 2,
    CardConfigurationTwoButtonFooterOnly = 3,
    CardConfigurationOneButtonHeaderAndFooter = 4,
    CardConfigurationOneButtonHeaderOnly = 5,
    CardConfigurationOneButtonFooterOnly = 6,
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
- (NSArray *)stringRepresentationOfActionsAvailableForState;
- (NSDate *)timestamp;
- (NSArray *)actionsAvailableForState;
- (CardConfiguration)configuration;

//- (void)returnToPriorState;

@optional
- (nullable Practice *)practice;
- (nullable User *)primaryUser;
- (nullable User *)secondaryUser;

NS_ASSUME_NONNULL_END
@end

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

typedef NS_ENUM(NSUInteger, CardType) {

    CardTypeAppointment = 0,
    CardTypeConversation = 1,
    CardTypePayment = 2,
    CardTypeForm = 3,
    CardTypeVisitSummary = 4,
    CardTypeCustom = 5,
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

//
//  Card.h
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "CardActivityProtocol.h"
#import "Provider.h"

typedef enum CardType {
    
    CardTypeAppointment = 0,
    CardTypeConversation = 1,
    CardTypePayment = 2,
    CardTypeForm = 3,
    CardTypeVisitSummary = 4
    
} CardType;


@interface LEOCard : NSObject
NS_ASSUME_NONNULL_BEGIN
@property (strong, nonatomic) NSString *objectID;
@property (strong, nonatomic) NSNumber *priority;
@property (nonatomic) CardType type;
@property (strong, nonatomic) NSString *cardTypeDescription;

@property (strong, nonatomic) id associatedCardObject;

@property (weak, nonatomic, nullable) id<CardActivityProtocol> delegate;

- (instancetype)initWithObjectID:(NSString *)objectID priority:(NSNumber *)priority type:(CardType)type associatedCardObject:(id)associatedCardObject;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;


//abstract methods
- (UIImage *)icon;
- (UIColor *)tintColor;
- (NSString *)title;
- (NSString *)body;
- (CardLayout)layout;
- (NSArray *)stringRepresentationOfActionsAvailableForState;
- (nullable User *)secondaryUser;
- (nullable User *)primaryUser;
- (NSDate *)timestamp;
- (NSArray *)actionsAvailableForState;

- (void)returnToPriorState;

NS_ASSUME_NONNULL_END
@end
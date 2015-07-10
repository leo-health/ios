//
//  Card.h
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "LEOConstants.h"
#import "CardActivityProtocol.h"
#import "Provider.h"

@interface LEOCard : NSObject
NS_ASSUME_NONNULL_BEGIN
@property (strong, nonatomic) NSString *objectID;
@property (strong, nonatomic) NSNumber *priority;
@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSArray *associatedCardObjects;

@property (nonatomic, nullable) id<CardActivityProtocol> delegate;

- (instancetype)initWithObjectID:(NSString *)objectID priority:(NSNumber *)priority type:(NSString *)type associatedCardObjects:(NSArray *)associatedCardObjects;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;


//abstract methods
- (UIImage *)icon;
- (UIColor *)tintColor;
- (NSString *)title;
- (NSString *)body;
- (CardLayout)layout;
- (NSArray *)stringRepresentationOfActionsAvailableForState;
- (Provider *)secondaryUser;
- (User *)primaryUser;
- (NSDate *)timestamp;
- (NSArray *)actionsAvailableForState;

- (void)returnToPriorState;

NS_ASSUME_NONNULL_END
@end
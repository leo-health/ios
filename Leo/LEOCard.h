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

@property (strong, nonatomic, nonnull) id associatedCardObject;

@property (nonatomic, nullable) id<CardActivityProtocol> delegate;

- (nonnull instancetype)initWithObjectID:(NSString *)objectID priority:(NSNumber *)priority type:(NSString *)type associatedCardObject:(nonnull id)associatedCardObject;

- (nonnull instancetype)cardWithDictionary:(nonnull NSDictionary *)jsonResponse;



//abstract methods
- (nonnull UIImage *)icon;
- (nonnull UIColor *)tintColor;
- (nonnull NSString *)title;
- (nonnull NSString *)body;
- (CardLayout)layout;
- (nonnull NSArray *)stringRepresentationOfActionsAvailableForState;
- (nonnull Provider *)secondaryUser;
- (nonnull User *)primaryUser;
- (nonnull NSDate *)timestamp;
- (nonnull NSArray *)actionsAvailableForState;

- (void)returnToPriorState;

NS_ASSUME_NONNULL_END
@end
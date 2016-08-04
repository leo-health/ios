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
#import "LEOCardProtocol.h"



@interface LEOCard : NSObject

NS_ASSUME_NONNULL_BEGIN
@property (strong, nonatomic) NSString *objectID;
@property (strong, nonatomic) NSNumber *priority;
@property (nonatomic) CardType type;
@property (strong, nonatomic) NSString *cardTypeDescription;

@property (strong, nonatomic) id associatedCardObject;

@property (weak, nonatomic) id<CardActivityProtocol> activityDelegate;
@property (weak, nonatomic) id<LEOCardProtocol> cardDelegate;

// designated
- (instancetype)initWithObjectID:(NSString *)objectID priority:(NSNumber *)priority type:(CardType)type associatedCardObject:(_Nullable id)associatedCardObject;

// convenience
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

+ (instancetype)cardWithCardType:(CardType)cardType;
+ (instancetype)cardWithCardType:(CardType)cardType withJSONDictionary:(NSDictionary *)jsonResponse;

+ (CardType)cardTypeWithString:(NSString *)cardTypeString;
+ (NSString *)stringWithCardType:(CardType)cardType;

- (id)targetForState; // default button target to self.associatedCardObject

NS_ASSUME_NONNULL_END
@end
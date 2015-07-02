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

@property (strong, nonatomic, nonnull) NSNumber *id;
@property (strong, nonatomic, nonnull) NSNumber *priority;

@property (strong, nonatomic, nonnull, readonly) id associatedCardObject;

@property (nonatomic, nullable) id<CardActivityProtocol> delegate;

- (nonnull instancetype)initWithID:(nonnull NSNumber *)id priority:(nonnull NSNumber *)priority associatedCardObject:(nonnull id)associatedCardObject;

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

@end
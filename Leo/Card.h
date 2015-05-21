//
//  Card.h
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Card : NSObject

@property (strong, nonatomic, nonnull) NSNumber *id;
@property (strong, nonatomic, nonnull) NSString *state;
@property (strong, nonatomic, nonnull) NSString *title;
@property (strong, nonatomic, nonnull) NSString *body;
@property (strong, nonatomic, nonnull) User *primaryUser;
@property (strong, nonatomic, nullable) User *secondaryUser;
@property (strong, nonatomic, nonnull) NSDate *timestamp;
@property (strong, nonatomic, nonnull) NSNumber *priority;
@property (nonatomic) NSInteger type;

- (nonnull instancetype)initWithID:(nonnull NSNumber *)id state:(nonnull NSString *)state title:(nonnull NSString *)title body:(nonnull NSString *)body primaryUser:(nonnull User *)primaryUser secondaryUser:(nonnull User *)secondaryUser timestamp:(nonnull NSDate *)timestamp priority:(nonnull NSNumber *)priority type:(NSInteger)type;

- (nonnull instancetype)cardWithDictionary:(nonnull NSDictionary *)jsonResponse;

@end
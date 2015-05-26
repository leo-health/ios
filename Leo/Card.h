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

@interface Card : NSObject

@property (strong, nonatomic, nonnull) NSNumber *id;
@property (nonatomic) CardState state;
@property (strong, nonatomic, nonnull) NSString *title;
@property (strong, nonatomic, nonnull) NSString *body;
@property (strong, nonatomic, nonnull) User *primaryUser;
@property (strong, nonatomic, nullable) User *secondaryUser;
@property (strong, nonatomic, nonnull) NSDate *timestamp;
@property (strong, nonatomic, nonnull) NSNumber *priority;
@property (nonatomic) CardActivity activity;
@property (nonatomic) CardFormat format;

- (nonnull instancetype)initWithID:(nonnull NSNumber *)id state:(CardState)state title:(nonnull NSString *)title body:(nonnull NSString *)body primaryUser:(nonnull User *)primaryUser secondaryUser:(nonnull User *)secondaryUser timestamp:(nonnull NSDate *)timestamp priority:(nonnull NSNumber *)priority activity:(CardActivity)activity;

- (nonnull instancetype)cardWithDictionary:(nonnull NSDictionary *)jsonResponse;

@end
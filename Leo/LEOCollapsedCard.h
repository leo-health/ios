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



@interface LEOCollapsedCard : NSObject

@property (strong, nonatomic, nonnull) NSNumber *id;
@property (nonatomic) NSInteger state;
@property (strong, nonatomic, nonnull) NSNumber *priority;

@property (strong, nonatomic, nonnull, readonly) id associatedCardObject;

//@property (strong, nonatomic, nonnull) id activity;

- (nonnull instancetype)initWithID:(nonnull NSNumber *)id state:(NSInteger)state priority:(nonnull NSNumber *)priority associatedCardObject:(nonnull id)associatedCardObject;
- (nonnull instancetype)cardWithDictionary:(nonnull NSDictionary *)jsonResponse;



//abstract methods
- (nonnull NSString *)title;
- (nonnull NSString *)body;
- (CardLayout)layout;
- (nonnull NSArray *)stringRepresentationOfActionsAvailableForState;
- (nonnull User *)secondaryUser;
- (nonnull User *)primaryUser;
- (nonnull NSDate *)timestamp;

@end
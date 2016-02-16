//
//  LEOCardConversation.h
//  Leo
//
//  Created by Zachary Drossman on 7/13/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOCard.h"

@interface LEOCardConversation : LEOCard <LEOCardProtocol>
NS_ASSUME_NONNULL_BEGIN

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;
- (instancetype)initWithObjectID:(NSString *)objectID priority:(NSNumber *)priority associatedCardObject:(id)associatedCardObjectDictionary;

- (UIImage *)icon;
- (UIColor *)tintColor;
- (NSString *)title;
- (NSString *)body;
- (NSArray *)stringRepresentationOfActionsAvailableForState;
- (NSDate *)timestamp;
- (NSArray *)actionsAvailableForState;

- (nullable User *)secondaryUser;
- (nullable User *)primaryUser;

NS_ASSUME_NONNULL_END
@end

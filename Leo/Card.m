//
//  Card.m
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Card.h"
#import "LEOConstants.h"

@implementation Card

- (nonnull instancetype)initWithID:(nonnull NSNumber *)id state:(nonnull NSString *)state title:(nonnull NSString *)title body:(nonnull NSString *)body primaryUser:(nonnull User *)primaryUser secondaryUser:(nonnull User *)secondaryUser timestamp:(nonnull NSDate *)timestamp priority:(nonnull NSNumber *)priority type:(NSInteger)type;
{
    self = [super init];
    if (self) {
        _id = id;
        _state = state;
        _title = title;
        _body = body;
        _primaryUser = primaryUser;
        _secondaryUser = secondaryUser;
        _timestamp = timestamp;
        _priority = priority;
        _type = type;
    }
    return self;
}

- (nonnull instancetype)cardWithDictionary:(nonnull NSDictionary *)jsonResponse {
   
    return [self initWithID:jsonResponse[APIParamCardID]
               state:jsonResponse[APIParamCardState]
               title:jsonResponse[APIParamCardTitle]
                body:jsonResponse[APIParamCardBody]
         primaryUser:jsonResponse[APIParamCardPrimaryUser]
       secondaryUser:jsonResponse[APIParamCardSecondaryUser]
           timestamp:jsonResponse[APIParamCardTimeStamp]
            priority:jsonResponse[APIParamCardPriority]
                type:[jsonResponse[APIParamCardType] integerValue]];
    
}


@end

//
//  Card.m
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOCollapsedCard.h"
#import "LEOConstants.h"

@implementation LEOCollapsedCard

#pragma mark - Initializers

- (nonnull instancetype)initWithID:(nonnull NSNumber *)id state:(NSInteger)state priority:(nonnull NSNumber *)priority associatedCardObject:(nonnull id)associatedCardObject {

    self = [super init];
    if (self) {
        _id = id;
        _state = state;
        _priority = priority;
        _associatedCardObject = associatedCardObject;
    }
    
    return self;
}

- (nonnull instancetype)cardWithDictionary:(nonnull NSDictionary *)jsonResponse {
   
    return [self initWithID:jsonResponse[APIParamCardID]
               state:[jsonResponse[APIParamCardState] integerValue]
            priority:jsonResponse[APIParamCardPriority]
       associatedCardObject:jsonResponse[APIParamAssociatedCardObject]];
}


#pragma mark - Abstract methods
- (CardLayout)layout {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSString *)title {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];

}

- (NSString *)body {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (nonnull NSDate *)timestamp {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];

}

- (nonnull NSArray *)stringRepresentationOfActionsAvailableForState {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

-(nonnull UIImage *)icon {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    
}

-(nonnull User *)primaryUser {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

-(nonnull User *)secondaryUser {

@throw [NSException exceptionWithName:NSInternalInconsistencyException
                               reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                             userInfo:nil];
}

-(nonnull NSArray *)actionsAvailableForState {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];

}
@end

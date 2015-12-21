//
//  Card.m
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOCard.h"
#import "LEOCardAppointment.h"

@implementation LEOCard

#pragma mark - Initializers

- (instancetype)initWithObjectID:(NSString *)objectID priority:(NSNumber *)priority type:(CardType)type associatedCardObject:(id)associatedCardObject {
    
    self = [super init];
    
    if (self) {
        _objectID = objectID;
        _priority = priority;
        _type = type;
        _associatedCardObject = associatedCardObject;
    }
    
    return self;
}

//MARK: Should this be abstract?

- (instancetype)initWithJSONDictionary:(NSDictionary *)cardDictionary {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

+ (instancetype)cardWithCardType:(CardType)cardType {

    switch (cardType) {
        case CardTypeAppointment:
            return [LEOCardAppointment new];
    }

    return nil;
}

+ (instancetype)cardWithCardType:(CardType)cardType withJSONDictionary:(NSDictionary *)jsonResponse {

    switch (cardType) {
        case CardTypeAppointment:
            return [[LEOCardAppointment alloc] initWithJSONDictionary:jsonResponse];
    }

    return nil;
}

- (void)revertChanges {
    
}

//+ (NSArray *)cardsFromJSONDictionary:(NSDictionary *)jsonResponse {
//
//    NSArray *jsonCards = jsonResponse[@"cards"];
//
//    NSMutableArray *cards = [[NSMutableArray alloc] init];
//
//    for (NSDictionary *jsonCard in jsonCards) {
//        LEOCard *card = [self cardFromCardDictionary:jsonCard];
//        [cards addObject:card];
//    }
//
//    return cards;
//}

@end

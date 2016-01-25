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

+ (NSArray *)cardTypes {

    // ????: Changing cardTypes requires this to change. There must be a safer way to do this
    return @[
             @"CardTypeUndefined",
             @"CardTypeAppointment",
             @"CardTypeConversation",
             @"CardTypePayment",
             @"CardTypeForm",
             @"CardTypeVisitSummary",
             @"CardTypeCustom"
             ];
}

+ (CardType)cardTypeWithString:(NSString *)cardTypeString {
    NSUInteger index = [[self cardTypes] indexOfObject:cardTypeString];
    if (index == NSNotFound) {
        return CardTypeUndefined;
    }
    return index;
}

+ (NSString *)stringWithCardType:(CardType)cardType {
    NSArray *cardTypes = [self cardTypes];
    if (cardType < cardTypes.count) {
        return cardTypes[cardType];
    }
    return cardTypes[0]; //CardTypeUndefined
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

//
//  LEOCardService.m
//  Leo
//
//  Created by Zachary Drossman on 9/21/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOCardService.h"
#import "LEOAPISessionManager.h"
#import "LEOCardAppointment.h"
#import "LEOCardConversation.h"
#import "LEOCardDeepLink.h"

@implementation LEOCardService

- (void)getCardsWithCompletion:(void (^)(NSArray *cards, NSError *error))completionBlock {
    
    [[LEOCardService leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointCards params:nil completion:^(NSDictionary *rawResults, NSError *error) {
        
        //FIXME: Need to change for "data"?
        
        NSArray *dataArray = rawResults[APIParamData];
        
        NSMutableArray *cards = [[NSMutableArray alloc] init];
        
        for (id jsonCard in dataArray) {
            
            NSString *cardType = jsonCard[APIParamType];
            
            if ([cardType isEqualToString:CardTypeNameAppointment]) {
                LEOCardAppointment *card = [[LEOCardAppointment alloc] initWithJSONDictionary:jsonCard];
                [cards addObject:card];
            }
            
            if ([cardType isEqualToString:CardTypeNameConversation]) {
                LEOCardConversation *card = [[LEOCardConversation alloc] initWithJSONDictionary:jsonCard];
                [cards addObject:card];
            }

            if ([cardType isEqualToString:CardTypeNameDeepLink]) {
                [cards addObject:[[LEOCardDeepLink alloc] initWithJSONDictionary:jsonCard]];
            }
        }
        if (completionBlock) {
            completionBlock(cards, error);
        }
    }];
}

- (void)deleteCardWithID:(NSString *)objectID completion:(void (^)(NSError *error))completionBlock {

    NSMutableDictionary *params = [NSMutableDictionary new];
    params[APIParamID] = objectID;

    [[LEOCardService leoSessionManager] standardDELETERequestForJSONDictionaryToAPIWithEndpoint:APIEndpointCards params:params completion:^(NSDictionary *rawResults, NSError *error) {

        if (completionBlock) {
            completionBlock(error);
        }
    }];
}

+ (LEOAPISessionManager *)leoSessionManager {
    return [LEOAPISessionManager sharedClient];
}

@end

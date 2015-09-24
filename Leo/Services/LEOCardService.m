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


@implementation LEOCardService

- (void)getCardsWithCompletion:(void (^)(NSArray *cards, NSError *error))completionBlock {
    
    [[LEOCardService leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointCards params:nil completion:^(NSDictionary *rawResults, NSError *error) {
        
        //FIXME: Need to change for "data"?
        
        NSArray *dataArray = rawResults[APIParamData];
        
        NSMutableArray *cards = [[NSMutableArray alloc] init];
        
        for (id jsonCard in dataArray) {
            
            NSString *cardType = jsonCard[APIParamType];
            
            if ([cardType isEqualToString:@"appointment"]) {
                LEOCardAppointment *card = [[LEOCardAppointment alloc] initWithDictionary:jsonCard];
                [cards addObject:card];
            }
            
            if ([cardType isEqualToString:@"conversation"]) {
                LEOCardConversation *card = [[LEOCardConversation alloc] initWithDictionary:jsonCard];
                [cards addObject:card];
            }
        }
        if (completionBlock) {
            
            completionBlock(cards, error);
        }
    }];
}

+ (LEOAPISessionManager *)leoSessionManager {
    return [LEOAPISessionManager sharedClient];
}

@end

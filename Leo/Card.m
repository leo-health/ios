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

- (nonnull instancetype)initWithID:(nonnull NSNumber *)id state:(CardState)state title:(nonnull NSString *)title body:(nonnull NSString *)body primaryUser:(nonnull User *)primaryUser secondaryUser:(nonnull User *)secondaryUser timestamp:(nonnull NSDate *)timestamp priority:(nonnull NSNumber *)priority activity:(CardActivity)activity {
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
        _activity = activity;
        _format = [self determineCardFormat];
    }
    return self;
}

- (nonnull instancetype)cardWithDictionary:(nonnull NSDictionary *)jsonResponse {
   
    return [self initWithID:jsonResponse[APIParamCardID]
               state:[jsonResponse[APIParamCardState] integerValue]
               title:jsonResponse[APIParamCardTitle]
                body:jsonResponse[APIParamCardBody]
         primaryUser:jsonResponse[APIParamCardPrimaryUser]
       secondaryUser:jsonResponse[APIParamCardSecondaryUser]
           timestamp:jsonResponse[APIParamCardTimeStamp]
            priority:jsonResponse[APIParamCardPriority]
                activity:[jsonResponse[APIParamCardActivity] integerValue]];
    
}

- (CardFormat)determineCardFormat {
    
    //TODO: Define rest of formats for activity/state combinations
    switch (self.activity) {
        case CardActivityAppointment:
            
            switch (self.state) {
                    
                case CardStateNew:
                    return CardFormatTwoButtonPrimaryOnly;
                    
                case CardStateContinue:
                    return CardFormatTwoButtonSecondaryAndPrimary;
                    
                default:
                    return CardFormatUndefined;
            }
            
        case CardActivityConversation:
            
            switch (self.state) {
                default:
                    return CardFormatTwoButtonSecondaryOnly;
            }
            
        case CardActivityVisit:
            
            switch (self.state) {
                    
                case CardStateNew:
                    return CardFormatTwoButtonPrimaryOnly;
                    
                default:
                    return CardFormatUndefined;
            }
            
    }
    
    return CardFormatUndefined;
}


@end

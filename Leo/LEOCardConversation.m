//
//  LEOCardConversation.m
//  Leo
//
//  Created by Zachary Drossman on 7/13/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOCardConversation.h"

#import "LEOCardAppointment.h"
#import <NSDate+DateTools.h>
#import "UIColor+LeoColors.h"
#import "Patient.h"
#import "Conversation.h"
#import "Message.h"

@interface LEOCardConversation ()

@property (strong, nonatomic) Conversation *conversation;

@end

@implementation LEOCardConversation

static NSString *kActionSelectorReply = @"reply";
static NSString *kActionSelectorCallUs = @"callUs";

- (instancetype)initWithObjectID:(NSString *)objectID priority:(NSNumber *)priority associatedCardObject:(id)associatedCardObjectDictionary {
    
    self = [super initWithObjectID:objectID priority:priority type:CardTypeConversation associatedCardObject:associatedCardObjectDictionary];
    
    if (self) {
        
        Conversation *conversation = [[Conversation alloc] initWithJSONDictionary:associatedCardObjectDictionary];
        
        self.associatedCardObject = conversation;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)jsonCard {
    
    return [self initWithObjectID:jsonCard[APIParamID]
                         priority:jsonCard[APIParamCardPriority]
             associatedCardObject:jsonCard[APIParamCardData]];
}


-(Conversation *)conversation {
    
    return (Conversation *)self.associatedCardObject; //FIXME: Update to account for multiple objects at some point...
}

- (CardLayout)layout {
    
    switch (self.conversation.statusCode) {
            
        case ConversationStatusCodeClosed:
        case ConversationStatusCodeOpen:
        case ConversationStatusCodeNewMessages:
        case ConversationStatusCodeReadMessages:
        case ConversationStatusCodeUndefined:
            return CardLayoutTwoButtonSecondaryOnly;
    }
}

- (NSString *)title {
    
    switch (self.conversation.statusCode) {
            
        case ConversationStatusCodeClosed:
        case ConversationStatusCodeOpen:
        case ConversationStatusCodeReadMessages:
        case ConversationStatusCodeUndefined:
            return @"Chat with Leo";
            
        case ConversationStatusCodeNewMessages:
            return  @"You have new messages";
    }
}

- (NSString *)body {
    
    NSString *bodyText;
    
    switch (self.conversation.statusCode) {
            
        case ConversationStatusCodeClosed:
        case ConversationStatusCodeOpen:
        case ConversationStatusCodeNewMessages:
        case ConversationStatusCodeReadMessages:
        case ConversationStatusCodeUndefined: {
            Message *message = self.conversation.messages.lastObject;
            
            if (message.text) {
                bodyText = message.text;
            } else {
                bodyText = [NSString stringWithFormat:@"%@ has sent you a media message.", message.sender.fullName];
            }
        }
    }
    
    return bodyText;
}

-(nonnull UIColor *)tintColor {
    return [UIColor leoBlue];
}

- (nonnull NSArray *)stringRepresentationOfActionsAvailableForState {
    
    switch (self.conversation.statusCode) {
        
        case ConversationStatusCodeClosed:
        case ConversationStatusCodeOpen:
        case ConversationStatusCodeNewMessages:
        case ConversationStatusCodeReadMessages:
        case ConversationStatusCodeUndefined:
            return @[@"REPLY", @"CALL US"];
    }
}

- (nonnull NSArray *)actionsAvailableForState {
    
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    
    switch (self.conversation.statusCode) {
            
        case ConversationStatusCodeClosed:
        case ConversationStatusCodeOpen:
        case ConversationStatusCodeNewMessages:
        case ConversationStatusCodeReadMessages:
        case ConversationStatusCodeUndefined: {

            NSString *buttonOneAction = kActionSelectorReply;
            [actions addObject:buttonOneAction];
            
            NSString *buttonTwoAction = kActionSelectorCallUs;
            [actions addObject:buttonTwoAction];
            
            break;
        }
    }
    
    return actions;
}

- (void)reply {
    
    self.conversation.priorStatusCode = self.conversation.statusCode;
    self.conversation.statusCode = ConversationStatusCodeOpen;
    [self.delegate didUpdateObjectStateForCard:self];
}

- (void)callUs {
    
    [self.delegate didUpdateObjectStateForCard:self];
}

- (void)dismiss {
    self.conversation.statusCode = ConversationStatusCodeClosed;
    [self.delegate didUpdateObjectStateForCard:self];
}

- (void)returnToPriorState {
    self.conversation.statusCode = self.conversation.priorStatusCode;
}

-(nullable User *)primaryUser {
    
    return nil;
}

-(nullable User *)secondaryUser {
    
    Message *message = self.conversation.messages[0];
    return message.sender;
}


//FIXME: Not sure what data we actually want for a timestamp.
- (nonnull NSDate *)timestamp {
    
    return [NSDate date];
}

-(nonnull UIImage *)icon {
    return [UIImage imageNamed:@"Icon-Chat"];
}


@end

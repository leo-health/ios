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

- (instancetype)initWithObjectID:(NSString *)objectID priority:(NSNumber *)priority type:(CardType)type associatedCardObject:(id)associatedCardObjectDictionary {
    
    self = [super initWithObjectID:objectID priority:priority type:type associatedCardObject:associatedCardObjectDictionary];
    
    if (self) {
        
        Conversation *conversation = [[Conversation alloc] initWithJSONDictionary:associatedCardObjectDictionary];
        
        self.associatedCardObject = conversation;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)jsonCard {
    
    return [self initWithObjectID:jsonCard[APIParamID]
                         priority:jsonCard[APIParamCardPriority]
                             type:[jsonCard[APIParamType] integerValue]
             associatedCardObject:jsonCard[APIParamCardData]];
}


-(Conversation *)conversation {
    
    return (Conversation *)self.associatedCardObject; //FIXME: Update to account for multiple objects at some point...
}

- (CardLayout)layout {
    
    switch (self.conversation.statusCode) {
            
        case ConversationStatusCodeClosed:
            return CardLayoutTwoButtonSecondaryOnly;
            break;
            
        case ConversationStatusCodeOpen:
            return CardLayoutUndefined;
            
        break;
    }
}

- (NSString *)title {
    
    NSString *titleText;
    
    switch (self.conversation.statusCode) {
            
        case ConversationStatusCodeClosed:
            titleText = @"Chat with Leo";
            break;
            
        case ConversationStatusCodeOpen:
            titleText = @"Chat with Leo";
            break;
    }
    
    return titleText;
}

- (NSString *)body {
    
    NSString *bodyText;
    
    switch (self.conversation.statusCode) {
            
        case ConversationStatusCodeClosed: {
            Message *message = self.conversation.messages[0];
            
            if (message.text) {
                bodyText = message.text;
            } else {
                bodyText = [NSString stringWithFormat:@"%@ has sent you a media message.", message.sender];
            }
            break;
        }
        case ConversationStatusCodeOpen: {
            bodyText = nil;
            break;
        }
    }
    
    return bodyText;
}

-(nonnull UIColor *)tintColor {
    return [UIColor leoBlue];
}

- (nonnull NSArray *)stringRepresentationOfActionsAvailableForState {
    
    NSArray *actionStrings;
    
    switch (self.conversation.statusCode) {
        
        case ConversationStatusCodeClosed: {
            actionStrings = @[@"REPLY", @"CALL US"];
            break;
        }
        case ConversationStatusCodeOpen: {
            actionStrings = nil;
            break;
        }
    }
    
    return actionStrings;
}

- (nonnull NSArray *)actionsAvailableForState {
    
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    
    switch (self.conversation.statusCode) {
            
        case ConversationStatusCodeClosed: {

            NSString *buttonOneAction = kActionSelectorReply;
            [actions addObject:buttonOneAction];
            
            NSString *buttonTwoAction = kActionSelectorCallUs;
            [actions addObject:buttonTwoAction];
            
            break;
        }
        case ConversationStatusCodeOpen: {
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
    return [UIImage imageNamed:@"Chat-Icon"];
}


@end

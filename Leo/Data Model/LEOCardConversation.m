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
#import "MessageImage.h"
#import "MessageText.h"
#import "Guardian.h"

//FIXME: Update to reflect new paradigm, where associatedCardObject actions are associated with the associatedCardObject and NOT the card (where they should be.)
@interface LEOCardConversation ()

@property (strong, nonatomic) Conversation *conversation;

@end

@implementation LEOCardConversation

static NSString *kActionSelectorReply = @"reply";
static NSString *kActionSelectorCallUs = @"call";

- (instancetype)initWithObjectID:(NSString *)objectID priority:(NSNumber *)priority associatedCardObject:(id)associatedCardObject {
    
    Conversation *conversation;

    if ([associatedCardObject isKindOfClass:[NSDictionary class]]) {
        conversation = [[Conversation alloc] initWithJSONDictionary:associatedCardObject];
    } else {
        conversation = associatedCardObject;
    }

    self = [super initWithObjectID:objectID priority:priority type:CardTypeConversation associatedCardObject:conversation];

    if (self) {

        [self commonInit];
    }

    return self;
}

- (void)commonInit {

    [self setupNotifications];
}

- (void)setupNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusChanged) name:kNotificationStatusChanged object:self.associatedCardObject];
}

- (void)removeObservers {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationStatusChanged object:self.associatedCardObject];
}

- (void)dealloc {

    [self removeObservers];
}

-(void)statusChanged {
    [self.activityDelegate didUpdateObjectStateForCard:self];
}


- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    return [self initWithObjectID:jsonResponse[APIParamID]
                         priority:jsonResponse[APIParamCardPriority]
             associatedCardObject:jsonResponse[APIParamCardData]];
}


-(Conversation *)conversation {
    
    return (Conversation *)self.associatedCardObject; //FIXME: Update to account for multiple objects at some point...
}

- (CardConfiguration)configuration {
    
    switch (self.conversation.statusCode) {
            
        case ConversationStatusCodeClosed:
        case ConversationStatusCodeOpen:
        case ConversationStatusCodeNewMessages:
        case ConversationStatusCodeReadMessages:
        case ConversationStatusCodeCallUs:
        case ConversationStatusCodeUndefined:
            return CardConfigurationTwoButtonHeaderAndFooter;
    }
}

- (NSString *)title {
    
    switch (self.conversation.statusCode) {
            
        case ConversationStatusCodeClosed:
        case ConversationStatusCodeOpen:
        case ConversationStatusCodeReadMessages:
        case ConversationStatusCodeCallUs:
        case ConversationStatusCodeUndefined:
            return @"We are here to help";
            
        case ConversationStatusCodeNewMessages:
            return  @"You have new messages";
    }
}

- (NSString *)body {
    
    NSString *bodyText;

    Message *message = self.conversation.messages.lastObject;

    switch (self.conversation.statusCode) {
            
        case ConversationStatusCodeClosed:
        case ConversationStatusCodeOpen:
        case ConversationStatusCodeNewMessages:
        case ConversationStatusCodeReadMessages:
        case ConversationStatusCodeCallUs:
        case ConversationStatusCodeUndefined: {

            if ([message.sender isKindOfClass:[Guardian class]]) {
                bodyText = @"We'll be in touch shortly";
            } else {

                if ([message isKindOfClass:[MessageText class]]) {
                    bodyText = message.text;
                }

                if ([message isKindOfClass:[MessageImage class]]) {
                    NSString *senderName = message.sender.fullName ?: @"Someone";
                    bodyText = [NSString stringWithFormat:@"%@ sent an image.", senderName];
                }
            }
        }
    }
    
    return bodyText;
}

-(nonnull UIColor *)tintColor {
    return [UIColor leo_blue];
}

- (nonnull NSArray *)stringRepresentationOfActionsAvailableForState {
    
    switch (self.conversation.statusCode) {
        
        case ConversationStatusCodeClosed:
        case ConversationStatusCodeOpen:
        case ConversationStatusCodeNewMessages:
        case ConversationStatusCodeReadMessages:
        case ConversationStatusCodeCallUs:
        case ConversationStatusCodeUndefined:
            return @[@"MESSAGE US", @"CALL US"];
    }
}

- (nonnull NSArray *)actionsAvailableForState {
    
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    
    switch (self.conversation.statusCode) {
            
        case ConversationStatusCodeClosed:
        case ConversationStatusCodeOpen:
        case ConversationStatusCodeNewMessages:
        case ConversationStatusCodeReadMessages:
        case ConversationStatusCodeCallUs:
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


-(nullable User *)primaryUser {
    
    return nil;
}

-(nullable User *)secondaryUser {
    return [[self.conversation.messages lastObject] sender];
}

- (nonnull NSDate *)timestamp {
    return [[self.conversation.messages lastObject] createdAt];
}

-(nonnull UIImage *)icon {
    return [UIImage imageNamed:@"Icon-Chat"];
}


@end

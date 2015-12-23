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


//FIXME: Update to reflect new paradigm, where associatedCardObject actions are associated with the associatedCardObject and NOT the card (where they should be.)
@interface LEOCardConversation ()

@property (strong, nonatomic) Conversation *conversation;

@end

@implementation LEOCardConversation

static NSString *kActionSelectorReply = @"reply";
static NSString *kActionSelectorCallUs = @"callUs";

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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusChanged) name:@"Status-Changed" object:self.associatedCardObject];
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

    Message *message = self.conversation.messages.lastObject;

    switch (self.conversation.statusCode) {
            
        case ConversationStatusCodeClosed:
        case ConversationStatusCodeOpen:
        case ConversationStatusCodeNewMessages:
        case ConversationStatusCodeReadMessages:
        case ConversationStatusCodeUndefined: {

            if ([message isKindOfClass:[MessageText class]]) {
                bodyText = message.text;
            }

            if ([message isKindOfClass:[MessageImage class]]) {
                bodyText = @"You have been sent an image.";
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

//
//  ConversationParticipant.h
//  Leo
//
//  Created by Zachary Drossman on 5/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Conversation, User;

@interface ConversationParticipant : NSManagedObject

@property (nonatomic, retain) NSNumber * participantRole;
@property (nonatomic, retain) NSSet *conversations;
@property (nonatomic, retain) User *participant;
@end

@interface ConversationParticipant (CoreDataGeneratedAccessors)

- (void)addConversationsObject:(Conversation *)value;
- (void)removeConversationsObject:(Conversation *)value;
- (void)addConversations:(NSSet *)values;
- (void)removeConversations:(NSSet *)values;

@end

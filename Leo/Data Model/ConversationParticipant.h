//
//  ConversationParticipant.h
//  
//
//  Created by Zachary Drossman on 5/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Conversation, User;

@interface ConversationParticipant : NSManagedObject

@property (nonatomic, retain) NSNumber * participantID;
@property (nonatomic, retain) NSString * participantRole;
@property (nonatomic, retain) NSSet *conversations;
@property (nonatomic, retain) User *user;
@end

@interface ConversationParticipant (CoreDataGeneratedAccessors)

- (void)addConversationsObject:(Conversation *)value;
- (void)removeConversationsObject:(Conversation *)value;
- (void)addConversations:(NSSet *)values;
- (void)removeConversations:(NSSet *)values;

@end

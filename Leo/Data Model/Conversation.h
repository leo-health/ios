//
//  Conversation.h
//  
//
//  Created by Zachary Drossman on 5/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ConversationParticipant, Message;

@interface Conversation : NSManagedObject

@property (nonatomic, retain) NSNumber * archived;
@property (nonatomic, retain) NSDate * archivedAt;
@property (nonatomic, retain) NSNumber * archivedByID;
@property (nonatomic, retain) NSNumber * conversationID;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * familyID;
@property (nonatomic, retain) NSDate * lastMessageCreated;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *messages;
@property (nonatomic, retain) NSSet *participants;
@end

@interface Conversation (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(Message *)value;
- (void)removeMessagesObject:(Message *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;

- (void)addParticipantsObject:(ConversationParticipant *)value;
- (void)removeParticipantsObject:(ConversationParticipant *)value;
- (void)addParticipants:(NSSet *)values;
- (void)removeParticipants:(NSSet *)values;

@end

//
//  Conversation.h
//  Leo
//
//  Created by Zachary Drossman on 5/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ConversationParticipant, Message;

@interface Conversation : NSManagedObject

@property (nonatomic, retain) NSNumber * archived;
@property (nonatomic, retain) NSDate * archivedAt;
@property (nonatomic, retain) NSString * archivedByID;
@property (nonatomic, retain) NSString * conversationID;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * familyID;
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

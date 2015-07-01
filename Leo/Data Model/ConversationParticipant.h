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
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, strong) NSNumber * participantRole;
@property (nonatomic, strong) Conversation *conversation;
@property (nonatomic, strong) User *participant;


NS_ASSUME_NONNULL_END
@end

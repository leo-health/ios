//
//  Message.h
//  
//
//  Created by Zachary Drossman on 5/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Conversation, ReadReceipt;

@interface Message : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * escalatedAt;
@property (nonatomic, retain) NSNumber * escalatedByID;
@property (nonatomic, retain) NSNumber * escalatedToID;
@property (nonatomic, retain) NSString * messageType;
@property (nonatomic, retain) NSDate * resolvedApprovedAt;
@property (nonatomic, retain) NSDate * resolvedRequestAt;
@property (nonatomic, retain) NSNumber * senderID;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) Conversation *conversation;
@property (nonatomic, retain) ReadReceipt *readReceipt;

@end

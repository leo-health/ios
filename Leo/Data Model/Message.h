//
//  Message.h
//  Leo
//
//  Created by Zachary Drossman on 5/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Conversation, ReadReceipt;

@interface Message : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * escalatedAt;
@property (nonatomic, retain) NSString * escalatedByID;
@property (nonatomic, retain) NSString * escalatedToID;
@property (nonatomic, retain) NSNumber * messageType;
@property (nonatomic, retain) NSDate * resolvedApprovedAt;
@property (nonatomic, retain) NSDate * resolvedRequestAt;
@property (nonatomic, retain) NSString * senderID;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) Conversation *conversation;
@property (nonatomic, retain) ReadReceipt *readReceipt;

@end

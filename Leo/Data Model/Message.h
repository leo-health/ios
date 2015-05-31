//
//  Message.h
//  Leo
//
//  Created by Zachary Drossman on 5/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Conversation;

@interface Message : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * escalatedAt;
@property (nonatomic, retain) NSString * messageID;
@property (nonatomic, retain) NSNumber * messageType;
@property (nonatomic, retain) NSDate * resolvedApprovedAt;
@property (nonatomic, retain) NSDate * resolvedRequestAt;
@property (nonatomic, retain) NSString * senderID;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) Conversation *conversation;

@end

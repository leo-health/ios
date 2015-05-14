//
//  ReadReceipt.h
//  
//
//  Created by Zachary Drossman on 5/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Message;

@interface ReadReceipt : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * messageID;
@property (nonatomic, retain) NSNumber * participantID;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) Message *message;

@end

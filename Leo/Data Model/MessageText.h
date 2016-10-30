//
//  MessageText.h
//  Leo
//
//  Created by Zachary Drossman on 12/22/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "Message.h"

@interface MessageText : Message
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, copy, readonly) NSString *text;

+ (NSDictionary *)serializeToJSON:(MessageText *)object;

/**
 *  Initializes and returns a message object having the given sender, escalatedTo user, escalatedBy user, status, statusCode, current
 *  system date (or the date on which the message was created) and escalatedAt date.
 *
 *  @param objectID    The unique identifier for the message.
 *  @param text        The body text of the message. This value must not be `nil`.
 *  @param sender      The unique user who sent the message. This value must not be `nil`.
 *  @param escalatedTo The unique user who escalated the message.
 *  @param escalatedBy The unique user who the message has been escalated to.
 *  @param status      The status of the message (read, unread, escalated, etc.)
 *  @param statusCode  The unique identifier of the status of the message.
 *  @param escalatedAt The datetime at which the message was escalated, if it was escalated.
 *
 *  @discussion Initializing a `JSQMessage` with this method will set `isMediaMessage` to `NO` and `createdAt` to the current system
 *  time.
 *
 *  @return An initialized `Message` object.
 */

+ (instancetype)messageWithObjectID:(nullable NSString *)objectID text:(NSString *)text sender:(User *)sender escalatedTo:(nullable User *)escalatedTo escalatedBy:(nullable User *)escalatedBy status:(nullable NSString *)status statusCode:(MessageStatusCode)statusCode escalatedAt:(nullable NSDate *)escalatedAt;



/**
 *  Initializes and returns a `Message` object having the given sender, escalatedTo user, escalatedBy user, status, statusCode, current
 *  system date (or the date on which the message was created) and escalatedAt date.
 *
 *  @param objectID    The unique identifier for the message.
 *  @param text        The body text of the message. This value must not be `nil`.
 *  @param sender      The unique user who sent the message. This value must not be `nil`.
 *  @param escalatedTo The unique user who escalated the message.
 *  @param escalatedBy The unique user who the message has been escalated to.
 *  @param status      The status of the message (read, unread, escalated, etc.)
 *  @param statusCode  The unique identifier of the status of the message.
 *  @param createdAt   The datetime at which the message was created. This value must not be `nil`.
 *  @param escalatedAt The datetime at which the message was escalated, if it was escalated.
 *
 *  @discussion Initializing a `JSQMessage` with this method will set `isMediaMessage` to `NO`.
 *
 *  @return An initialized `Message` object.
 */
- (instancetype)initWithObjectID:(nullable NSString *)objectID text:(NSString *)text sender:(User *)sender escalatedTo:(nullable User *)escalatedTo escalatedBy:(nullable User *)escalatedBy status:(nullable NSString *)status statusCode:(MessageStatusCode)statusCode createdAt:(NSDate *)createdAt escalatedAt:(nullable NSDate *)escalatedAt;

NS_ASSUME_NONNULL_END
@end

//
//  MessageImage.h
//  Leo
//
//  Created by Zachary Drossman on 12/22/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

@class LEOS3Image;

#import "Message.h"

@interface MessageImage : Message
NS_ASSUME_NONNULL_BEGIN

@property (copy, nonatomic, readonly) id<JSQMessageMediaData> media;
@property (strong, nonatomic) LEOS3Image *s3Image;

/**
 *  Initializes and returns a `Message` object having the given sender, escalatedTo user, escalatedBy user, status, statusCode, current
 *  system date (or the date on which the message was created) and escalatedAt date.
 *
 *  @param objectID    The unique identifier for the message.
 *  @param media       The media to be displayed as part of the message. This value must not be `nil`.
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
+ (instancetype)messageWithObjectID:(nullable NSString *)objectID media:(id<JSQMessageMediaData>)media sender:(User *)sender escalatedTo:(nullable User *)escalatedTo escalatedBy:(nullable User *)escalatedBy status:(nullable NSString *)status statusCode:(MessageStatusCode)statusCode createdAt:(NSDate*)createdAt escalatedAt:(nullable NSDate *)escalatedAt leoMedia:(nullable LEOS3Image *)s3Image;
/**
 *  Initializes and returns a `Message` object having the given sender, escalatedTo user, escalatedBy user, status, statusCode, current
 *  system date (or the date on which the message was created) and escalatedAt date.
 *
 *  @param objectID    The unique identifier for the message.
 *  @param media       The media to be displayed as part of the message. This value must not be `nil`.
 *  @param sender      The unique user who sent the message. This value must not be `nil`.
 *  @param escalatedTo The unique user who escalated the message.
 *  @param escalatedBy The unique user who the message has been escalated to.
 *  @param status      The status of the message (read, unread, escalated, etc.)
 *  @param statusCod   The unique identifier of the status of the message.
 *  @param createdAt   The datetime at which the message was created. This value must not be `nil`.
 *  @param escalatedAt The datetime at which the message was escalated, if it was escalated.
 *
 *  @discussion Initializing a `JSQMessage` with this method will set `isMediaMessage` to `YES`.
 *
 *  @return An initialized `Message` object.
 */
- (instancetype)initWithObjectID:(nullable NSString *)objectID media:(id<JSQMessageMediaData>)media sender:(User *)sender escalatedTo:(nullable User *)escalatedTo escalatedBy:(nullable User *)escalatedBy status:(nullable NSString *)status statusCode:(MessageStatusCode)statusCode createdAt:(NSDate *)createdAt escalatedAt:(nullable NSDate *)escalatedAt leoMedia:(LEOS3Image *)s3Image;


/**
 *  Initializes and returns a `Message` object given a raw JSON dictionary of key information
 *
 *  @param jsonResponse The JSON dictionary of message data. This dictionary must not be `nil`.
 *
 *  @discussion Initializing a `Message` with this method will require type data for introspection (e.g. media vs. text)
 *
 *  @return An initialized `Message` object if successful. Nil if not successful.
 */

NS_ASSUME_NONNULL_END
@end

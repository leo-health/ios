//
//  Message.h
//  Leo
//
//  Created by Zachary Drossman on 5/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <JSQMessagesViewController/JSQMessageData.h>
@class User;

@interface Message : NSObject <JSQMessageData, NSCopying>
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, copy) NSString *objectID;
@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, strong, nullable, readonly) User *escalatedTo;
@property (nonatomic, strong, nullable, readonly) User *escalatedBy;
@property (nonatomic) MessageStatusCode statusCode;
@property (nonatomic, copy, readonly) NSString *status;
@property (nonatomic, strong, readonly) User *sender;
@property (nonatomic, strong, readonly) NSDate *createdAt;
@property (nonatomic, strong, readonly) NSDate *escalatedAt;


/**
 *  Properties needed to comply with JSQMessageData Protocol
 */
@property (nonatomic) BOOL isMediaMessage;
@property (copy, nonatomic, readonly) id<JSQMessageMediaData> media;

#pragma mark - Initialization

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

+ (instancetype)messageWithObjectID:(nullable NSString *)objectID media:(id<JSQMessageMediaData>)media sender:(User *)sender escalatedTo:(nullable User *)escalatedTo escalatedBy:(nullable User *)escalatedBy status:(nullable NSString *)status statusCode:(MessageStatusCode)statusCode escalatedAt:(nullable NSDate *)escalatedAt;


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
- (instancetype)initWithObjectID:(nullable NSString *)objectID media:(id<JSQMessageMediaData>)media sender:(User *)sender escalatedTo:(nullable User *)escalatedTo escalatedBy:(nullable User *)escalatedBy status:(nullable NSString *)status statusCode:(MessageStatusCode)statusCode createdAt:(NSDate *)createdAt escalatedAt:(nullable NSDate *)escalatedAt;


/**
 *  Initializes and returns a `Message` object given a raw JSON dictionary of key information
 *
 *  @param jsonResponse The JSON dictionary of message data. This dictionary must not be `nil`.
 *
 *  @discussion Initializing a `Message` with this method will require type data for introspection (e.g. media vs. text)
 *
 *  @return An initialized `Message` object if successful. Nil if not successful.
 */
- (instancetype)initWithJSONDictionary:(nonnull NSDictionary *)jsonResponse;


/**
 *  Creates an `NSDictionary` from a `Message` object
 *
 *  @param message `Message` object from which to create `NSDictionary`
 *
 *  @return A complete `NSDictionary` of `Message` data. Field names to match those of server. See `LEOConstants.h` for more detail.
 */
+ (NSDictionary *)dictionaryFromMessage:(Message *)message;

NS_ASSUME_NONNULL_END
@end

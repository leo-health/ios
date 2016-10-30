//
//  Message.h
//  Leo
//
//  Created by Zachary Drossman on 5/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSQMessagesViewController/JSQMessageData.h>
#import "LEOJSONSerializable.h"

@class User;

typedef NS_ENUM(NSUInteger, LEOMessageType) {
    LEOMessageTypeText,
    LEOMessageTypeImage,
    LEOMessageTypeDeepLink,
    LEOMessageTypeVideo,
};

@interface Message : LEOJSONSerializable <JSQMessageData>
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, copy) NSString *objectID;
@property (nonatomic, strong, nullable, readonly) User *escalatedTo;
@property (nonatomic, strong, nullable, readonly) User *escalatedBy;
@property (nonatomic) MessageStatusCode statusCode;
@property (nonatomic, copy, readonly) NSString *status;
@property (nonatomic, strong, readonly) User *sender;
@property (nonatomic, strong, readonly) NSDate *createdAt;
@property (nonatomic, strong, readonly) NSDate *escalatedAt;

+ (instancetype)messageWithMessageType:(LEOMessageType)messageType;

/**
 *  Properties needed to comply with JSQMessageData Protocol
 */
@property (nonatomic) BOOL isMediaMessage;

#pragma mark - Initialization

- (instancetype)initWithObjectID:(nullable NSString *)objectID sender:(User *)sender escalatedTo:(nullable User *)escalatedTo escalatedBy:(nullable User *)escalatedBy status:(nullable NSString *)status statusCode:(MessageStatusCode)statusCode createdAt:(NSDate *)createdAt escalatedAt:(nullable NSDate *)escalatedAt isMediaMessage:(BOOL)isMediaMessage;


+ (instancetype)messageWithJSONDictionary:(NSDictionary *)jsonResponse;
+ (NSString *)extractObjectIDFromChannelData:(NSDictionary *)channelData;

/**
 *  Creates an `NSDictionary` from a `Message` object
 *
 *  @param message `Message` object from which to create `NSDictionary`
 *
 *  @return A complete `NSDictionary` of `Message` data. Field names to match those of server. See `LEOConstants.h` for more detail.
 */

+ (NSString *)typeFromTypeCode:(MessageTypeCode)code;
+ (NSDictionary *)serializeToJSON:(Message *)object;

NS_ASSUME_NONNULL_END
@end

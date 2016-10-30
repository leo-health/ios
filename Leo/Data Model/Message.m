//
//  Message.m
//  Leo
//
//  Created by Zachary Drossman on 5/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Message.h"
#import "MessageText.h"
#import "MessageImage.h"

#import "Conversation.h"

#import "UserFactory.h"
#import "User.h"
#import "Provider.h"
#import "Guardian.h"
#import "Support.h"

#import "NSDate+Extensions.h"
#import "NSDictionary+Extensions.h"
#import <AFNetworking/UIImage+AFNetworking.h>
#import <JSQPhotoMediaItem.h>
#import "LEOMessageService.h"

@interface Message()

@property (copy, nonatomic) NSString *senderId;

@end

@implementation Message

static NSString *const kText = @"text";
static NSString *const kImage = @"image";
static NSString *const kMessageID = @"message_id";

#pragma mark - <JSQMessageDataProtocol>

-(NSString *)senderId {
    
    if ([self.sender isKindOfClass:[Guardian class]]) {
        return [NSString stringWithFormat:@"%@F",((Guardian *)self.sender).familyID] ;
    }
    
    return self.sender.objectID;
}

-(NSString *)senderDisplayName {
    return self.sender.fullName;
}

-(NSDate *)date {
    return self.createdAt;
}

#pragma mark - Initialization

- (id)init {
    NSAssert(NO, @"%s is not a valid initializer for %@.", __PRETTY_FUNCTION__, [self class]);
    return nil;
}

- (instancetype)initWithObjectID:(nullable NSString *)objectID sender:(User *)sender escalatedTo:(nullable User *)escalatedTo escalatedBy:(nullable User *)escalatedBy status:(nullable NSString *)status statusCode:(MessageStatusCode)statusCode createdAt:(NSDate *)createdAt escalatedAt:(nullable NSDate *)escalatedAt isMediaMessage:(BOOL)isMediaMessage {
    
    self = [super init];
    
    if (self) {
        _objectID = objectID;
        _sender = sender;
        _escalatedTo = escalatedTo;
        _escalatedBy = escalatedBy;
        _status = status;
        _statusCode = statusCode;
        _createdAt = createdAt;
        _escalatedAt = escalatedAt;
        _isMediaMessage = isMediaMessage;
    }
    
    return self;
}


+ (NSString *)extractObjectIDFromChannelData:(NSDictionary *)channelData {
    return [[channelData objectForKey:kMessageID] stringValue];
}

+ (NSDictionary *)serializeToJSON:(Message *)object {

    if (!object) {
        return nil;
    }

    NSMutableDictionary *json = [NSMutableDictionary new];
    json[APIParamID] = object.objectID;
    json[APIParamMessageSender] = [object.sender serializeToJSON];
    json[APIParamStatus] = object.status;
    json[APIParamStatusID] = @(object.statusCode);
    json[APIParamCreatedDateTime] = [NSDate leo_stringifiedDateTime:object.createdAt];

    return [json copy];
}


//FIXME: LeoConstants missing some of these hence they have been commented out for the time-being.
+ (instancetype)messageWithJSONDictionary:(NSDictionary *)jsonResponse {

    NSString *objectID = [[jsonResponse leo_itemForKey:APIParamID] stringValue];
    MessageTypeCode typeCode = [self convertTypeToTypeCode:[jsonResponse leo_itemForKey:APIParamType]];

    User *sender = [UserFactory userFromJSONDictionary:jsonResponse[APIParamMessageSender]];

    User *escalatedTo;
    //    if (!(jsonResponse[APIParamMessageEscalatedTo] == [NSNull null])) {
    //        escalatedTo = [UserFactory userFromJSONDictionary:jsonResponse[APIParamMessageEscalatedTo]];
    //    }

    User *escalatedBy;
    //    if (jsonResponse[APIParamMessageEscalatedBy]) {
    //        escalatedBy = [UserFactory userFromJSONDictionary:jsonResponse[APIParamMessageEscalatedBy]];
    //    }

    NSString *status = [jsonResponse leo_itemForKey:APIParamStatus];
    MessageStatusCode statusCode = [[jsonResponse leo_itemForKey:APIParamStatusID] integerValue];

    //MARK: Decide if I need to bring this in even since it is only being used for introspection and not kept around afterward.
    NSDate *createdAt = [NSDate leo_dateFromDateTimeString:[jsonResponse leo_itemForKey:APIParamCreatedDateTime]];

    switch (typeCode) {
        case MessageTypeCodeText: {

            NSString *text = [jsonResponse leo_itemForKey:APIParamMessageBody];

            return [[MessageText alloc] initWithObjectID:objectID text:text sender:sender escalatedTo:escalatedTo escalatedBy:escalatedBy status:status statusCode:statusCode createdAt:createdAt escalatedAt:nil];
        }

        case MessageTypeCodeImage: {

            LEOS3Image *media = [[LEOS3Image alloc] initWithJSONDictionary:jsonResponse[APIParamMessageBody]];
            media.placeholder = [UIImage imageNamed:@"retry-placeholder"];

            // HACK: ????: init the media item with the cached image if it exists
            media.cachePolicy = [LEOCachePolicy cacheOnly];
            [media refreshIfNeeded]; // update the underlyingImage
            media.cachePolicy = nil; // reset the default policy to ensure the image is loaded from the remote if it doesn't exist in the cache
            
            JSQPhotoMediaItem *photoMediaItem = [[JSQPhotoMediaItem alloc] initWithImage:media.underlyingImage];

            return [MessageImage messageWithObjectID:objectID media:photoMediaItem sender:sender escalatedTo:escalatedTo escalatedBy:escalatedBy status:status statusCode:statusCode createdAt:createdAt escalatedAt:nil leoMedia:media];
        }

        case MessageTypeCodeUndefined:
            
            return nil;
    }
}

+ (MessageTypeCode)convertTypeToTypeCode:(NSString *)type {
    
    if ([type isEqualToString:kText]) {
        return MessageTypeCodeText;
    } else if ([type isEqualToString:kImage]) {
        return MessageTypeCodeImage;
    }
    
    return MessageTypeCodeUndefined;
}

+ (NSString *)typeFromTypeCode:(MessageTypeCode)code {
    switch (code) {
        case MessageTypeCodeText:
            return kText;

        case MessageTypeCodeImage:
            return kImage;

        default:
            return nil;
    }
}

- (NSUInteger)messageHash {
    return self.hash;
}

#pragma mark - NSObject Overrides

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    Message *aMessage = (Message *)object;
    
    if (self.isMediaMessage != aMessage.isMediaMessage) {
        return NO;
    }
    
    BOOL hasEqualContent = self.isMediaMessage ? [self.media isEqual:aMessage.media] : [self.text isEqualToString:aMessage.text];
    
    return [self.senderId isEqualToString:aMessage.senderId]
    && [self.senderDisplayName isEqualToString:aMessage.senderDisplayName]
    && ([self.date compare:aMessage.date] == NSOrderedSame)
    && hasEqualContent;
}

- (NSUInteger)hash {
    NSUInteger contentHash = self.isMediaMessage ? [self.media mediaHash] : self.text.hash;
    return self.senderId.hash ^ self.date.hash ^ contentHash;
}

- (id)debugQuickLookObject {
    return [self.media mediaView] ?: [self.media mediaPlaceholderView];
}


@end

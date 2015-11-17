//
//  Message.m
//  Leo
//
//  Created by Zachary Drossman on 5/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Message.h"
#import "Conversation.h"
#import "User.h"
#import "Provider.h"
#import "Guardian.h"
#import "Support.h"
#import "Patient.h"

#import "NSDate+Extensions.h"
#import "NSDictionary+Additions.h"

@interface Message()

@property (copy, nonatomic) NSString *senderId;

- (instancetype)initWithObjectID:(nullable NSString *)objectID sender:(User *)sender escalatedTo:(nullable User *)escalatedTo escalatedBy:(nullable User *)escalatedBy status:(nullable NSString *)status statusCode:(MessageStatusCode)statusCode createdAt:(NSDate *)createdAt escalatedAt:(nullable NSDate *)escalatedAt isMediaMessage:(BOOL)isMediaMessage;

@end

@implementation Message

static NSString *const kText = @"text";
static NSString *const kImage = @"image";

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




//FIXME: LeoConstants missing some of these hence they have been commented out for the time-being.
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    NSString *objectID = [[jsonResponse itemForKey:APIParamID] stringValue];
    NSString *text = [jsonResponse itemForKey:APIParamMessageBody];
    
    //FIXME: In order for this to work, need a helper to convert the URL to a media message
    id<JSQMessageMediaData> media = [jsonResponse itemForKey:APIParamMessageBody];
    
    User *sender = [self initializeWithJSONDictionary:[jsonResponse itemForKey:APIParamMessageSender]];
    
    NSDictionary *escalatedToDictionary = [jsonResponse itemForKey:APIParamMessageEscalatedTo];
    User *escalatedTo = [self initializeWithJSONDictionary:escalatedToDictionary];

    NSString *status = [jsonResponse itemForKey:APIParamStatus];
    MessageStatusCode statusCode = [[jsonResponse itemForKey:APIParamStatusID] integerValue];
    
    //MARK: Decide if I need to bring this in even since it is only being used for introspection and not kept around afterward.
    MessageTypeCode typeCode = [self convertTypeToTypeCode:[jsonResponse itemForKey:APIParamType]];
    NSDate *createdAt = [NSDate dateFromDateTimeString:[jsonResponse itemForKey:APIParamCreatedDateTime]];
        
    switch (typeCode) {
        case MessageTypeCodeText:
            return [[Message alloc] initWithObjectID:objectID text:text sender:sender escalatedTo:escalatedTo escalatedBy:nil status:status statusCode:statusCode createdAt:createdAt escalatedAt:nil];
            
        case MessageTypeCodeImage:
             return [[Message alloc] initWithObjectID:objectID media:media sender:sender escalatedTo:escalatedTo escalatedBy:nil status:status statusCode:statusCode createdAt:createdAt escalatedAt:nil];
            
        case MessageTypeCodeUndefined:
    
            return nil;
    }
}

- (MessageTypeCode)convertTypeToTypeCode:(NSString *)type {
    
    if ([type isEqualToString:kText]) {
        return MessageTypeCodeText;
    } else if ([type isEqualToString:kImage]) {
        return MessageTypeCodeImage;
    }
    
    return MessageTypeCodeUndefined;
}



//FIXME: This should not really be a part of the Message class. Let's figure out where this goes.
- (User *)initializeWithJSONDictionary:(NSDictionary *)jsonDictionary {
    
    NSInteger roleID = [jsonDictionary[APIParamRoleID] integerValue];
    
    switch (roleID) {
        case RoleCodeProvider:
            return [[Provider alloc] initWithJSONDictionary:jsonDictionary];
        
        case RoleCodeGuardian:
            return [[Guardian alloc] initWithJSONDictionary:jsonDictionary];
          
    
        case RoleCodePatient:
            return [[Patient alloc] initWithJSONDictionary:jsonDictionary];

        default:
            return [[User alloc] initWithJSONDictionary:jsonDictionary];
    }
}

+ (NSDictionary *)dictionaryFromMessage:(Message *)message {
    
    NSMutableDictionary *messageDictionary = [[NSMutableDictionary alloc] init];
    
    messageDictionary[APIParamID] = message.objectID;
    
    if (message.text) {
        messageDictionary[APIParamMessageBody] = message.text;
        messageDictionary[APIParamTypeID] = @0;
    } else {
        messageDictionary[APIParamMessageBody] = message.media;
        messageDictionary[APIParamTypeID] = @1;
    }
    
    messageDictionary[APIParamUser] = message.sender;
    messageDictionary[APIParamCreatedDateTime] = message.createdAt;
    messageDictionary[APIParamStatusID] = [NSNumber numberWithInteger:message.statusCode];
    
    return messageDictionary;
}

+ (instancetype)messageWithObjectID:(nullable NSString *)objectID text:(NSString *)text sender:(User *)sender escalatedTo:(nullable User *)escalatedTo escalatedBy:(nullable User *)escalatedBy status:(nullable NSString *)status statusCode:(MessageStatusCode)statusCode escalatedAt:(nullable NSDate *)escalatedAt {
    
    return [[Message alloc] initWithObjectID:objectID text:(NSString *)text sender:sender escalatedTo:escalatedTo escalatedBy:escalatedBy status:status statusCode:statusCode createdAt:[NSDate date] escalatedAt:escalatedAt];
}

- (instancetype)initWithObjectID:(nullable NSString *)objectID text:(NSString *)text sender:(User *)sender escalatedTo:(nullable User *)escalatedTo escalatedBy:(nullable User *)escalatedBy status:(nullable NSString *)status statusCode:(MessageStatusCode)statusCode createdAt:(NSDate *)createdAt escalatedAt:(nullable NSDate *)escalatedAt {
    
    self = [self initWithObjectID:objectID sender:sender escalatedTo:escalatedTo escalatedBy:escalatedBy status:status statusCode:statusCode createdAt:createdAt escalatedAt:escalatedAt isMediaMessage:NO];
    
    if (self) {
        _text = [text copy];
    }
    return self;
}

+ (instancetype)messageWithObjectID:(nullable NSString *)objectID media:(id<JSQMessageMediaData>)media sender:(User *)sender escalatedTo:(nullable User *)escalatedTo escalatedBy:(nullable User *)escalatedBy status:(nullable NSString *)status statusCode:(MessageStatusCode)statusCode escalatedAt:(nullable NSDate *)escalatedAt {
    
    return [[Message alloc] initWithObjectID:objectID media:media sender:sender escalatedTo:escalatedTo escalatedBy:escalatedBy status:status statusCode:statusCode createdAt:[NSDate date] escalatedAt:escalatedAt];
}

- (instancetype)initWithObjectID:(nullable NSString *)objectID media:(id<JSQMessageMediaData>)media sender:(User *)sender escalatedTo:(nullable User *)escalatedTo escalatedBy:(nullable User *)escalatedBy status:(nullable NSString *)status statusCode:(MessageStatusCode)statusCode createdAt:(NSDate *)createdAt escalatedAt:(nullable NSDate *)escalatedAt {
    
    self = [self initWithObjectID:objectID sender:sender escalatedTo:escalatedTo escalatedBy:escalatedBy status:status statusCode:statusCode createdAt:createdAt escalatedAt:escalatedAt isMediaMessage:YES];
    
    if (self) {
        _media = media;
    }
    return self;
}


- (id)init
{
    NSAssert(NO, @"%s is not a valid initializer for %@.", __PRETTY_FUNCTION__, [self class]);
    return nil;
}

- (NSUInteger)messageHash
{
    return self.hash;
}

#pragma mark - NSObject

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

- (NSUInteger)hash
{
    NSUInteger contentHash = self.isMediaMessage ? [self.media mediaHash] : self.text.hash;
    return self.senderId.hash ^ self.date.hash ^ contentHash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: senderId=%@, senderDisplayName=%@, date=%@, isMediaMessage=%@, text=%@, media=%@>",
            [self class], self.senderId, self.senderDisplayName, self.date, @(self.isMediaMessage), self.text, self.media];
}

- (id)debugQuickLookObject
{
    return [self.media mediaView] ?: [self.media mediaPlaceholderView];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    if (self.isMediaMessage) {
        return [[[self class] allocWithZone:zone] initWithObjectID:self.objectID media:self.media sender:self.sender escalatedTo:self.escalatedTo escalatedBy:self.escalatedBy status:self.status statusCode:self.statusCode createdAt:self.createdAt escalatedAt:self.escalatedAt];
    }
    
    return [[[self class] allocWithZone:zone] initWithObjectID:self.objectID text:self.text sender:self.sender escalatedTo:self.escalatedTo escalatedBy:self.escalatedBy status:self.status statusCode:self.statusCode createdAt:self.createdAt escalatedAt:self.escalatedAt];
}





@end

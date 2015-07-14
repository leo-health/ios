//
//  Message.m
//  Leo
//
//  Created by Zachary Drossman on 5/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Message.h"
#import "Conversation.h"
#import "LEOConstants.h"
#import "User.h"
#import "Provider.h"
#import "Guardian.h"
#import "Support.h"

@implementation Message

- (instancetype)initWithObjectID:(nullable NSString *)objectID body:(NSString *)body sender:(User *)sender escalatedTo:(nullable User *)escalatedTo escalatedBy:(nullable User *)escalatedBy status:(nullable NSString *)status statusID:(NSNumber *)statusID createdAt:(NSDate *)createdAt escalatedAt:(nullable NSDate *)escalatedAt type:(nullable NSString *)type typeID:(NSNumber *)typeID {
    
    self = [super init];
    
    if (self) {
        _objectID = objectID;
        _body = body;
        _sender = sender;
        _escalatedTo = escalatedTo;
        _escalatedBy = escalatedBy;
        _status = status;
        _statusID = statusID;
        _createdAt = createdAt;
        _escalatedAt = escalatedAt;
        _type = type;
        _typeID = typeID;
    }
    
    return self;
}


//FIXME: LeoConstants missing some of these hence they have been commented out for the time-being.
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    NSString *objectID = [jsonResponse[APIParamID] stringValue];
    NSString *body = jsonResponse[APIParamMessageBody];
    
    User *sender = [self initializeWithJSONDictionary:jsonResponse[APIParamMessageSender]];
    User *escalatedTo = [self initializeWithJSONDictionary:jsonResponse[APIParamMessageEscalatedTo]];
//    User *escalatedBy = [self initializeWithJSONDictionary:jsonResponse[APIParamMessageEscalatedBy]];
    
    NSString *status = jsonResponse[APIParamStatus];
    NSNumber *statusID = jsonResponse[APIParamStatusID];
    
    NSString *type = jsonResponse[APIParamType];
    NSNumber *typeID = jsonResponse[APIParamTypeID];
    
//    NSDate *escalatedAt = jsonResponse[APIParamMessageEscalatedDateTime];
    NSDate *createdAt = jsonResponse[APIParamCreatedDateTime];
    
    //TODO: May need to protect against nil values...
    return [self initWithObjectID:objectID body:body sender:sender escalatedTo:escalatedTo escalatedBy:nil status:status statusID:statusID createdAt:createdAt escalatedAt:nil type:type typeID:typeID];
}


//FIXME: This should not be a part of the Message class. Let's figure out where this goes.
- (User *)initializeWithJSONDictionary:(NSDictionary *)jsonDictionary {
    
    if ([jsonDictionary[APIParamRole] isEqualToString:@"provider"]) {
        return [[Provider alloc] initWithJSONDictionary:jsonDictionary];
    }
    
    else if ([jsonDictionary[APIParamRole] isEqualToString:@"guardian"]) {
        return [[Guardian alloc] initWithJSONDictionary:jsonDictionary];
    }
    
    return [[User alloc] initWithJSONDictionary:jsonDictionary];
}

+ (NSDictionary *)dictionaryFromMessage:(Message *)message {
    
    NSMutableDictionary *messageDictionary = [[NSMutableDictionary alloc] init];
    
    messageDictionary[APIParamID] = message.objectID ? message.objectID : [NSNull null];
    messageDictionary[APIParamMessageBody] = message.body;
    messageDictionary[APIParamUser] = message.sender;
    messageDictionary[APIParamTypeID] = message.typeID;
    messageDictionary[APIParamCreatedDateTime] = message.createdAt;
    messageDictionary[APIParamStatusID] = message.statusID;
    
    return messageDictionary;
}

@end

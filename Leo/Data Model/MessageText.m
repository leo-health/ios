//
//  MessageText.m
//  Leo
//
//  Created by Zachary Drossman on 12/22/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "MessageText.h"

@interface MessageText ()

@end

@implementation MessageText

+ (instancetype)messageWithObjectID:(nullable NSString *)objectID text:(NSString *)text sender:(User *)sender escalatedTo:(nullable User *)escalatedTo escalatedBy:(nullable User *)escalatedBy status:(nullable NSString *)status statusCode:(MessageStatusCode)statusCode escalatedAt:(nullable NSDate *)escalatedAt {

    return [[MessageText alloc] initWithObjectID:objectID text:(NSString *)text sender:sender escalatedTo:escalatedTo escalatedBy:escalatedBy status:status statusCode:statusCode createdAt:[NSDate date] escalatedAt:escalatedAt];
}

- (instancetype)initWithObjectID:(nullable NSString *)objectID text:(NSString *)text sender:(User *)sender escalatedTo:(nullable User *)escalatedTo escalatedBy:(nullable User *)escalatedBy status:(nullable NSString *)status statusCode:(MessageStatusCode)statusCode createdAt:(NSDate *)createdAt escalatedAt:(nullable NSDate *)escalatedAt {

    self = [super initWithObjectID:objectID sender:sender escalatedTo:escalatedTo escalatedBy:escalatedBy status:status statusCode:statusCode createdAt:createdAt escalatedAt:escalatedAt isMediaMessage:NO];

    if (self) {
        _text = [text copy];
    }
    return self;
}

-(NSString *)description {

    return [NSString stringWithFormat:@"<%@: senderId=%@, senderDisplayName=%@, date=%@, text=%@>",
            [self class], self.senderId, self.senderDisplayName, self.date, self.text];
}

+ (NSDictionary *)serializeToJSON:(MessageText *)object {

    if (!object) {
        return nil;
    }

    NSMutableDictionary *json = [[super serializeToJSON:object] mutableCopy];

    json[APIParamType] = [super typeFromTypeCode:MessageTypeCodeText];
    json[APIParamMessageBody] = object.text;

    return [json copy];
}

@end

//
//  MessageImage.m
//  Leo
//
//  Created by Zachary Drossman on 12/22/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "MessageImage.h"

@interface MessageImage ()


@end

@implementation MessageImage


+ (instancetype)messageWithObjectID:(nullable NSString *)objectID media:(id<JSQMessageMediaData>)media sender:(User *)sender escalatedTo:(nullable User *)escalatedTo escalatedBy:(nullable User *)escalatedBy status:(nullable NSString *)status statusCode:(MessageStatusCode)statusCode escalatedAt:(nullable NSDate *)escalatedAt urlString:(NSString *)urlString {

    return [[MessageImage alloc] initWithObjectID:objectID media:media sender:sender escalatedTo:escalatedTo escalatedBy:escalatedBy status:status statusCode:statusCode createdAt:[NSDate date] escalatedAt:escalatedAt urlString:urlString];
}

- (instancetype)initWithObjectID:(nullable NSString *)objectID media:(id<JSQMessageMediaData>)media sender:(User *)sender escalatedTo:(nullable User *)escalatedTo escalatedBy:(nullable User *)escalatedBy status:(nullable NSString *)status statusCode:(MessageStatusCode)statusCode createdAt:(NSDate *)createdAt escalatedAt:(nullable NSDate *)escalatedAt urlString:(NSString *)urlString {

    self = [super initWithObjectID:objectID sender:sender escalatedTo:escalatedTo escalatedBy:escalatedBy status:status statusCode:statusCode createdAt:createdAt escalatedAt:escalatedAt isMediaMessage:YES];

    if (self) {
        _media = media;
        _urlString = urlString;
    }
    return self;
}

-(NSString *)description {

    return [NSString stringWithFormat:@"<%@: senderId=%@, senderDisplayName=%@, date=%@, media=%@>",
            [self class], self.senderId, self.senderDisplayName, self.date, self.media];
}

@end

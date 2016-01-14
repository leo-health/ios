//
//  MessageImage.m
//  Leo
//
//  Created by Zachary Drossman on 12/22/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "MessageImage.h"
#import "LEOS3Image.h"

@interface MessageImage ()


@end

@implementation MessageImage


+ (instancetype)messageWithObjectID:(nullable NSString *)objectID media:(id<JSQMessageMediaData>)media sender:(User *)sender escalatedTo:(nullable User *)escalatedTo escalatedBy:(nullable User *)escalatedBy status:(nullable NSString *)status statusCode:(MessageStatusCode)statusCode escalatedAt:(nullable NSDate *)escalatedAt leoMedia:(LEOS3Image *)s3Image {

    return [[MessageImage alloc] initWithObjectID:objectID media:media sender:sender escalatedTo:escalatedTo escalatedBy:escalatedBy status:status statusCode:statusCode createdAt:[NSDate date] escalatedAt:escalatedAt leoMedia:s3Image];
}

- (instancetype)initWithObjectID:(nullable NSString *)objectID media:(id<JSQMessageMediaData>)media sender:(User *)sender escalatedTo:(nullable User *)escalatedTo escalatedBy:(nullable User *)escalatedBy status:(nullable NSString *)status statusCode:(MessageStatusCode)statusCode createdAt:(NSDate *)createdAt escalatedAt:(nullable NSDate *)escalatedAt leoMedia:(LEOS3Image *)s3Image {

    self = [super initWithObjectID:objectID sender:sender escalatedTo:escalatedTo escalatedBy:escalatedBy status:status statusCode:statusCode createdAt:createdAt escalatedAt:escalatedAt isMediaMessage:YES];

    if (self) {
        _media = media;
        _s3Image = s3Image;
    }
    return self;
}

-(NSString *)description {

    return [NSString stringWithFormat:@"<%@: senderId=%@, senderDisplayName=%@, date=%@, media=%@>",
            [self class], self.senderId, self.senderDisplayName, self.date, self.media];
}

@end

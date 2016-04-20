//
//  Notice.m
//  Leo
//
//  Created by Zachary Drossman on 4/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "Notice.h"
#import "NSDictionary+Extensions.h"

@implementation Notice

- (instancetype)initWithName:(NSString *)name
        attributedHeaderText:(NSAttributedString *)attributedHeaderString
          attributedBodyText:(NSAttributedString *)attributedBodyString
                actionAvailable:(BOOL)actionAvailable {

    self = [super init];

    if (self) {

        _name = name;
        _attributedHeaderText = attributedHeaderString;
        _attributedBodyText = attributedBodyString;
        _actionAvailable = actionAvailable;
    }

    return self;
}

- (instancetype)initWithName:(NSString *)name
                  headerText:(NSString *)headerString
                    bodyText:(NSString *)bodyString
                actionAvailable:(BOOL)actionAvailable {
    
    NSAttributedString *attributedHeaderString = [[NSAttributedString alloc] initWithString:headerString];
    NSAttributedString *attributedBodyString = [[NSAttributedString alloc] initWithString:bodyString];

    return [self initWithName:name
         attributedHeaderText:attributedHeaderString
           attributedBodyText:attributedBodyString
            actionAvailable:actionAvailable];
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {

    NSString *name = [jsonResponse leo_itemForKey:APIParamNoticeName];
    NSString *headerString = [jsonResponse leo_itemForKey:APIParamNoticeHeaderString];
    NSString *bodyString = [jsonResponse leo_itemForKey:APIParamNoticeBodyString];

    NSDictionary *headerAttributes = [jsonResponse leo_itemForKey:APIParamNoticeHeaderAttributes];
    NSDictionary *bodyAttributes = [jsonResponse leo_itemForKey:APIParamNoticeBodyAttributes];

    NSAttributedString *attributedHeaderText;
    NSAttributedString *attributedBodyText;

    BOOL actionAvailable =  [[jsonResponse leo_itemForKey:APIParamNoticeActionAvailable] boolValue];

    if (headerAttributes) {
        attributedHeaderText = [[NSAttributedString alloc] initWithString:headerString
                                                               attributes:headerAttributes];
    } else {
        attributedHeaderText = [[NSAttributedString alloc] initWithString:headerString];
    }

    if (bodyAttributes) {
        attributedBodyText = [[NSAttributedString alloc] initWithString:bodyString
                                                             attributes:bodyAttributes];
    } else {
        attributedBodyText = [[NSAttributedString alloc] initWithString:bodyString];
    }

    return [self initWithName:name attributedHeaderText:attributedHeaderText attributedBodyText:attributedBodyText actionAvailable:actionAvailable];
}

+ (NSArray *)noticesFromJSONArray:(NSArray *)jsonResponse {

    NSMutableArray *mutableNotices = [NSMutableArray new];

    for (NSDictionary *noticeDictionary in jsonResponse) {

        Notice *notice = [[self alloc] initWithJSONDictionary:noticeDictionary];

        [mutableNotices addObject:notice];
    }

    return [mutableNotices copy];
}

@end

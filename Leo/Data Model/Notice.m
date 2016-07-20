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
        headerText:(NSString *)headerString
          bodyText:(NSString *)bodyString
            headerAttributes:(NSDictionary *)headerAttributes
              bodyAttributes:(NSDictionary *)bodyAttributes
             actionAvailable:(BOOL)actionAvailable {

    self = [super init];

    if (self) {

        _name = name;
        _headerText = headerString;
        _bodyText = bodyString;
        _headerAttributes = headerAttributes;
        _bodyAttributes = bodyAttributes;
        _actionAvailable = actionAvailable;
    }

    return self;
}

#pragma mark - LEOJSONSerializable

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {

    if (!jsonDictionary) {
        return nil;
    }

    NSString *name = [jsonDictionary leo_itemForKey:APIParamNoticeName];
    NSString *headerString = [jsonDictionary leo_itemForKey:APIParamNoticeHeaderString];
    NSString *bodyString = [jsonDictionary leo_itemForKey:APIParamNoticeBodyString];

    NSDictionary *headerAttributes = [jsonDictionary leo_itemForKey:APIParamNoticeHeaderAttributes];
    NSDictionary *bodyAttributes = [jsonDictionary leo_itemForKey:APIParamNoticeBodyAttributes];

    BOOL actionAvailable =  [[jsonDictionary leo_itemForKey:APIParamNoticeActionAvailable] boolValue];

    return [self initWithName:name
                   headerText:headerString
                     bodyText:bodyString
             headerAttributes:headerAttributes
               bodyAttributes:bodyAttributes
              actionAvailable:actionAvailable];
}

+ (NSDictionary *)serializeToJSON:(Notice *)notice {

    if (!notice) {
        return nil;
    }

    NSMutableDictionary *noticeJSON = [NSMutableDictionary new];
    noticeJSON[APIParamNoticeName] = notice.name;
    noticeJSON[APIParamNoticeHeaderString] = notice.headerText;
    noticeJSON[APIParamNoticeBodyString] = notice.bodyText;
    noticeJSON[APIParamNoticeHeaderAttributes] = notice.headerAttributes;
    noticeJSON[APIParamNoticeBodyAttributes] = notice.bodyAttributes;
    noticeJSON[APIParamNoticeActionAvailable] = @(notice.actionAvailable);

    return noticeJSON;
}


@end

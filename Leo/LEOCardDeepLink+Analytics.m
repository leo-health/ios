//
//  LEOCardDeepLink+Analytics.m
//  Leo
//
//  Created by Adam Fanslau on 8/26/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOCardDeepLink+Analytics.h"

@implementation LEOCardDeepLink (Analytics)

- (NSDictionary *)analyticAttributes {

    NSMutableDictionary *attributes = [NSMutableDictionary new];
    attributes[@"category"] = self.category;
    attributes[@"title"] = self.title;
    attributes[@"url"] = self.deepLink;
    attributes[@"link_preview_id"] = self.objectID;

    return [attributes copy];
}

@end

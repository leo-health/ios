//
//  Guardian+Analytics.m
//  Leo
//
//  Created by Annie Graham on 6/21/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "Guardian+Analytics.h"

@implementation Guardian (Analytics)

- (NSDictionary *)getAttributes {

    NSDictionary *attributeDictionary =
    @{@"Primary guardian": [self isPrimaryString],
      @"Membership type": [self membershipTypeString]};

    return attributeDictionary;
}

- (NSString *)isPrimaryString {
    return self.primary ? @"YES" : @"NO";
}

- (NSString *)membershipTypeString {
    return [Guardian membershipStringFromType:self.membershipType];
}

@end

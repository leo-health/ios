//
//  Guardian+Analytics.m
//  Leo
//
//  Created by Annie Graham on 6/21/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "Guardian+Analytics.h"

@implementation Guardian (Analytics)

-(NSString *)isPrimaryString{
    if (self.primary) return @"YES";
    return @"NO";
}

-(NSString *)membershipTypeString{
    return [Guardian membershipStringFromType:self.membershipType];
}


@end

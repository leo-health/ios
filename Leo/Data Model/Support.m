//
//  Support.m
//  Leo
//
//  Created by Zachary Drossman on 7/9/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Support.h"

@implementation Support

//FIXME: Update with correct constants.
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    self = [super initWithJSONDictionary:jsonResponse];
    
    if (self) {
        _jobTitle = jsonResponse[APIParamUserJobTitle];

        // handle the case where job title is not included in the API response. From a data modeling perspective, the credentials feild is overloaded here, but allow for it as a fail safe
        if (!_jobTitle) {
            NSArray *credentials = jsonResponse[APIParamUserCredentials];
            if (credentials.count > 0) {
                _jobTitle = credentials[0];
            }
        }
    }
    
    return self;
}

- (NSString *)description {
    
    NSString *superDesc = [super description];
    
    NSString *subDesc = [NSString stringWithFormat:@"\nName: %@ %@",self.firstName, self.lastName];
    
    return [superDesc stringByAppendingString:subDesc];
}

@end

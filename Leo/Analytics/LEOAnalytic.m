//
//  LEOAnalytic.m
//  Leo
//
//  Created by Annie Graham on 7/14/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOAnalytic.h"
#import "p_LEOAnalyticEvent.h"
#import "p_LEOAnalyticIntent.h"
#import "p_LEOAnalyticScreen.h"
#import "LEOFamilyService.h"
#import "Family+Analytics.h"
#import "LEOUserService.h"
#import "Guardian+Analytics.h"

@implementation LEOAnalytic

+ (void)tagType:(LEOAnalyticType)type
           name:(NSString *)eventName {

    Family *family = [LEOFamilyService new].getFamily;
    Guardian *guardian = [LEOUserService new].getCurrentUser;
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    if (family != nil) {
       [attributes addEntriesFromDictionary:[family analyticAttributes]];
    }
    if (guardian != nil) {
        [attributes addEntriesFromDictionary:[guardian analyticAttributes]];
    }
    if ([attributes count] > 0) {
        [self tagType:type
                 name:eventName
           attributes:attributes];
    }
    
    switch (type) {

        case LEOAnalyticTypeEvent:
            [p_LEOAnalyticEvent tagEvent:eventName];
            break;

        case LEOAnalyticTypeIntent:
            [p_LEOAnalyticIntent tagEvent:eventName];
            break;

        case LEOAnalyticTypeScreen:
            [p_LEOAnalyticScreen tagScreen:eventName];
            break;
    }
}

+ (void)tagType:(LEOAnalyticType)type
           name:(NSString *)eventName
     attributes:(NSDictionary *)attributes {

    NSMutableDictionary *mutableDictionary = [attributes mutableCopy];
    if ([attributes objectForKey:@"Number of Children"]==nil) {

        Family *family = [LEOFamilyService new].getFamily;
        if (family != nil) {
            [mutableDictionary addEntriesFromDictionary:[family analyticAttributes]];
        }
    }

    if ([attributes objectForKey:kAnalyticAttributeMembershipType]==nil) {

        Guardian *guardian = [LEOUserService new].getCurrentUser;
        if (guardian != nil) {
            [mutableDictionary addEntriesFromDictionary:[guardian analyticAttributes]];
        }
    }

    switch (type) {

        case LEOAnalyticTypeEvent:
            [p_LEOAnalyticEvent tagEvent:eventName
                            attributes:mutableDictionary];
            break;

        case LEOAnalyticTypeIntent:
            [p_LEOAnalyticIntent tagEvent:eventName
                             attributes:mutableDictionary];
            break;
            
        case LEOAnalyticTypeScreen:
            [p_LEOAnalyticScreen tagScreen:eventName];
            break;
    }
}



@end

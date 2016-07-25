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

    NSDictionary *attributes = [self availableFamilyAndGuardianAttributes];

    if ([attributes count] > 0) {

        [self tagType:type
                 name:eventName
availableFamilyAndGuardianAttributes:attributes];
    } else {

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
    
}

+ (void)tagType:(LEOAnalyticType)type
           name:(NSString *)eventName
availableFamilyAndGuardianAttributes:(NSDictionary *)attributes {

    switch (type) {

        case LEOAnalyticTypeEvent:
            [p_LEOAnalyticEvent tagEvent:eventName
                              attributes:attributes];
            break;

        case LEOAnalyticTypeIntent:
            [p_LEOAnalyticIntent tagEvent:eventName
                               attributes:attributes];
            break;

        case LEOAnalyticTypeScreen:
            [p_LEOAnalyticScreen tagScreen:eventName];
            break;
    }
}

+ (void)tagType:(LEOAnalyticType)type
           name:(NSString *)eventName
     attributes:(NSDictionary *)attributes {

    NSMutableDictionary *mutableDictionary = [[self availableFamilyAndGuardianAttributes] mutableCopy];
    [mutableDictionary addEntriesFromDictionary:attributes];

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

+ (NSDictionary *)availableFamilyAndGuardianAttributes {

    Family *family = [LEOFamilyService new].getFamily;
    Guardian *guardian = [LEOUserService new].getCurrentUser;
    NSMutableDictionary *mutableAttributes = [NSMutableDictionary new];

    if (family && family.numberOfChildren > 0 && guardian != nil && guardian.membershipType!=MembershipTypeIncomplete) {
        [mutableAttributes addEntriesFromDictionary:[family analyticAttributes]];
    }
    if (guardian) {
        [mutableAttributes addEntriesFromDictionary:[guardian analyticAttributes]];
    }

    return [mutableAttributes copy];
}



@end

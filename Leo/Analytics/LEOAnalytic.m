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

@implementation LEOAnalytic

+ (void)tagType:(LEOAnalyticType)type
           name:(NSString *)eventName {

    switch(type){

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

    switch(type){

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


@end

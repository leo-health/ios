//
//  LEOAnalytic.m
//  Leo
//
//  Created by Annie Graham on 7/14/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOAnalytic.h"
#import "LEOAnalyticEvent.h"
#import "LEOAnalyticIntent.h"
#import "LEOAnalyticScreen.h"

@implementation LEOAnalytic

+ (void)tagType:(LEOAnalyticType)type
      eventName:(NSString *)eventName{

    switch(type){

        case LEOAnalyticTypeEvent:
            [LEOAnalyticEvent tagEvent:eventName];
            break;
        case LEOAnalyticTypeIntent:
            [LEOAnalyticIntent tagEvent:eventName];
            break;
        case LEOAnalyticTypeScreen:
            [LEOAnalyticScreen tagScreen:eventName];
            break;
    }
}

+ (void)tagType:(LEOAnalyticType)type
      eventName:(NSString *)eventName
     attributes:(NSDictionary *)attributes{

    switch(type){

        case LEOAnalyticTypeEvent:

            [LEOAnalyticEvent tagEvent:eventName
                            attributes:attributes];
            break;
        case LEOAnalyticTypeIntent:

            [LEOAnalyticIntent tagEvent:eventName
                             attributes:attributes];
            break;
        case LEOAnalyticTypeScreen:

            [LEOAnalyticScreen tagScreen:eventName];
            break;
    }
}


@end

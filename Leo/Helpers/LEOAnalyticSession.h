//
//  LEOAnalyticSession.h
//  Leo
//
//  Created by Zachary Drossman on 4/1/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOAnalyticSession : NSObject

+ (LEOAnalyticSession *)startSessionWithSessionEventName:(NSString *)sessionEventName;
- (NSNumber *)sessionLength;
- (void)completeSession;

@end

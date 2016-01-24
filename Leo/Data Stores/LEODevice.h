//
//  LEODevice.h
//  Leo
//
//  Created by Zachary Drossman on 11/20/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEODevice : NSObject

+ (instancetype)createTokenWithString:(NSString *)token;
+ (NSString *)deviceToken;
+ (NSString *)deviceType;
+ (NSString *)osVersionString;
+ (NSDictionary *)jsonDictionary;

@end

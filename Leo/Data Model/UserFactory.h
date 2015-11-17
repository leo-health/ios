//
//  UserFactory.h
//  Leo
//
//  Created by Zachary Drossman on 11/17/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserFactory : NSObject

+ (User *)userFromJSONDictionary:(NSDictionary *)dictionary;

@end

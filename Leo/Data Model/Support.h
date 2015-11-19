//
//  Support.h
//  Leo
//
//  Created by Zachary Drossman on 7/9/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "User.h"

@interface Support : User
NS_ASSUME_NONNULL_BEGIN

@property (copy, nonatomic) NSString *jobTitle;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

NS_ASSUME_NONNULL_END

@end

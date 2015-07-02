//
//  Practice.h
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Practice : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (copy, nonatomic) NSString *id;
@property (strong, nonatomic) NSArray *providers;

- (instancetype)initWithID:(NSString *)id providers:(NSArray *)providers;
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

NS_ASSUME_NONNULL_END
@end

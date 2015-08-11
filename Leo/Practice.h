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

@property (copy, nonatomic) NSString *objectID;
@property (strong, nonatomic) NSArray *providers;
@property (copy, nonatomic) NSString *addressLine1;
@property (copy, nonatomic) NSString *addressLine2;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *zip;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *email;


//FIXME: Come back and add rest of properties to initializer and then in .m file for initWithJSONDictionary. DOn't need these for right now to get the app in "working" order.

- (instancetype)initWithObjectID:(NSString *)id providers:(NSArray *)providers;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

NS_ASSUME_NONNULL_END
@end

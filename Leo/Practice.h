//
//  Practice.h
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Practice : NSObject <NSCoding>
NS_ASSUME_NONNULL_BEGIN

@property (copy, nonatomic) NSString *objectID;
@property (copy, nonatomic, readonly) NSArray *providers;
@property (copy, nonatomic, readonly) NSArray *staff;
@property (copy, nonatomic, readonly) NSString *addressLine1;
@property (copy, nonatomic, readonly) NSString *addressLine2;
@property (copy, nonatomic, readonly) NSString *city;
@property (copy, nonatomic, readonly) NSString *state;
@property (copy, nonatomic, readonly) NSString *zip;
@property (copy, nonatomic, readonly) NSString *phone;
@property (copy, nonatomic, readonly) NSString *email;

//FIXME: Come back and add rest of properties to initializer and then in .m file for initWithJSONDictionary. DOn't need these for right now to get the app in "working" order.

- (instancetype)initWithObjectID:(NSString *)objectID providers:(NSArray *)providers staff:(NSArray *)staff addressLine1:(NSString *)addressLine1 addressLine2:(NSString *)addressLine2 city:(NSString *)city state:(NSString *)state zip:(NSString *)zip phone:(NSString *)phone email:(NSString *)email;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

NS_ASSUME_NONNULL_END
@end

//
//  InsurancePlan.h
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Insurer;

@interface InsurancePlan : NSObject

@property (strong, nonatomic) NSString *objectID;
@property (strong, nonatomic) Insurer *insurer;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) BOOL supported;

- (instancetype)initWithObjectID:(NSString *)objectID insurer:(Insurer *)insurer name:(NSString *)name supported:(BOOL)supported;
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@end

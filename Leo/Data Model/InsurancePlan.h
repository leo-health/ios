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
@property (strong, nonatomic) NSString *insurerID;
@property (strong, nonatomic) NSString *insurerName;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *plans;
@property (nonatomic) BOOL supported;

- (instancetype)initSupportedPlanWithJSONDictionary:(NSDictionary *)jsonDictionary;
- (instancetype)initWithObjectID:(NSString *)objectID insurerID:(NSString *)insurerID insurerName:(NSString *)insurerName name:(NSString *)name;

@end

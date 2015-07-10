//
//  Family.h
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Patient;
@class Guardian;

@interface Family : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (copy, nonatomic) NSString *objectID;
@property (strong, nonatomic) NSArray *guardians;
@property (strong, nonatomic) NSArray *patients;

- (instancetype)initWithObjectID:(NSString *)objectID guardians:(NSArray *)guardians patients:(NSArray *)patients;
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

- (void)addChild:(Patient *)child;
- (void)addGuardian:(Guardian *)guardian;

NS_ASSUME_NONNULL_END
@end

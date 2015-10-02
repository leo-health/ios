//
//  PrepFamily.h
//  Leo
//
//  Created by Zachary Drossman on 10/1/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Patient;
@class Guardian;

@interface PrepFamily : NSObject <NSCoding>
NS_ASSUME_NONNULL_BEGIN

@property (copy, nonatomic) NSString *objectID;
@property (copy, nonatomic) NSMutableArray *guardians;
@property (copy, nonatomic) NSMutableArray *patients;

- (instancetype)initWithObjectID:(NSString *)objectID guardians:(NSArray *)guardians patients:(NSArray *)patients;
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

- (void)addChild:(Patient *)child;
- (void)addGuardian:(Guardian *)guardian;

NS_ASSUME_NONNULL_END
@end
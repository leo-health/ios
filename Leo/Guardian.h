//
//  Caretaker.h
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Guardian : User
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic) BOOL primary;
@property (copy, nonatomic) NSString *relationship;
@property (nonatomic, copy, nullable) NSString *familyID;

- (instancetype)initWithObjectID:(nullable NSString *)objectID familyID:(nullable NSString *)familyID title:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(NSString *)email photoURL:(nullable NSURL *)photoURL photo:(nullable UIImage *)photo primary:(BOOL)primary relationship:(NSString *)relationship;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

+ (NSDictionary *)dictionaryFromUser:(Guardian *)caretaker;

NS_ASSUME_NONNULL_END
@end

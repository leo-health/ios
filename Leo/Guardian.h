//
//  Caretaker.h
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Guardian : User <NSCoding>
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic) BOOL primary;
@property (copy, nonatomic) NSString *relationship;
@property (nonatomic, copy, nullable) NSString *familyID;

- (instancetype)initWithObjectID:(nullable NSString *)objectID familyID:(NSString *)familyID title:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(NSString *)email avatarURL:(nullable NSString *)avatarURL avatar:(nullable UIImage *)avatar primary:(BOOL)primary relationship:(nullable NSString *)relationship;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

+ (NSDictionary *)dictionaryFromUser:(Guardian *)guardian;

NS_ASSUME_NONNULL_END
@end

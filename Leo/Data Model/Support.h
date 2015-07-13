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

@property (copy, nonatomic) NSString *roleDisplayName;
@property (copy, nonatomic) NSString *roleID;

- (instancetype)initWithObjectID:(nullable NSString *)objectID title:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(NSString *)email photoURL:(nullable NSURL *)photoURL photo:(UIImage *)photo roleID:(NSString *)roleID roleDisplayName:(NSString *)roleDisplayName;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

+ (NSDictionary *)dictionaryFromUser:(Support *)support;

NS_ASSUME_NONNULL_END

@end

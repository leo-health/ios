//
//  Support.h
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Support : User
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, copy) NSString *role;

-(instancetype)initWithObjectID:(nullable NSString *)objectID title:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(NSString *)email photoURL:(nullable NSURL *)photoURL photo:(UIImage *)photo role:(NSString *)role;

-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;


NS_ASSUME_NONNULL_END
@end

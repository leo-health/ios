//
//  LEOUserService.h
//  Leo
//
//  Created by Zachary Drossman on 9/21/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class User, SessionUser;

#import <Foundation/Foundation.h>

@interface LEOUserService : NSObject

//- (void)createUserWithUser:(User *)user password:(NSString *)password withCompletion:(void (^)( NSDictionary *  rawResults, NSError *error))completionBlock;
- (void)loginUserWithEmail:(NSString *)email password:(NSString *)password withCompletion:(void (^)(SessionUser *user, NSError *error))completionBlock;
- (void)enrollUser:(User *)user enrollmentToken:(NSString *)enrollmentToken password:(NSString *)password withCompletion:(void (^) (User *user, NSString *enrollmentToken, NSError *error))completionBlock;
- (void)resetPasswordWithEmail:(NSString *)email withCompletion:(void (^)(NSDictionary *  rawResults, NSError *error))completionBlock;
- (void)getAvatarForUser:(User *)user withCompletion:(void (^)(UIImage *rawImage, NSError *error))completionBlock;

@end

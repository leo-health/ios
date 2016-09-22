//
//  LEOUserDataSource.h
//  Leo
//
//  Created by Adam Fanslau on 7/15/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Guardian, LEOPromise;

@protocol LEOUserDataSource <NSObject>

NS_ASSUME_NONNULL_BEGIN

- (Guardian * _Nullable)getCurrentUser;
- (Guardian *)putCurrentUser:(Guardian *)guardian;
- (void)logout;

- (LEOPromise *)createUser:(Guardian *)newGuardian
      withPassword:(NSString *)password
    withCompletion:(void (^)(Guardian *guardian, NSError *error))completionBlock;

- (LEOPromise *)loginUserWithEmail:(NSString *)email
                  password:(NSString *)password
            withCompletion:(void (^)(Guardian *guardian, NSError *error))completionBlock;

- (LEOPromise *)logoutUserWithCompletion:(void (^)(BOOL success, NSError *error))completionBlock;

- (LEOPromise *)resetPasswordWithEmail:(NSString *)email
                withCompletion:(void (^)(NSDictionary *  rawResults, NSError *error))completionBlock;

- (LEOPromise *)changePasswordWithOldPassword:(NSString *)oldPassword
                          newPassword:(NSString *)newPassword
                   retypedNewPassword:(NSString *)retypedNewPassword
                       withCompletion:(void (^) (BOOL success, NSError *error))completionBlock;

- (LEOPromise *)getCurrentUserWithCompletion:(void (^) (Guardian *guardian, NSError *error))completionBlock;

- (LEOPromise *)putCurrentUser:(Guardian *)guardian
                withCompletion:(void (^) (Guardian* guardian, NSError *error))completionBlock;

- (LEOPromise *)addCaregiver:(Guardian *)user withCompletion:(void (^) (Guardian *guardian, NSError *error))completionBlock;

- (Guardian *)addCaregiver:(Guardian *)user;

- (void)createSessionWithCompletion:(LEOErrorBlock)completionBlock;

NS_ASSUME_NONNULL_END
@end

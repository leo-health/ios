//
//  Caretaker.h
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "InsurancePlan.h"
#import "LEOS3Image.h"

@interface Guardian : User <NSCopying>
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic) BOOL primary;
@property (copy, nonatomic) NSString *relationship;
@property (nonatomic, copy, nullable) NSString *familyID;
@property (copy, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) InsurancePlan *insurancePlan;
@property (nonatomic) MembershipType membershipType;
@property (nonatomic) BOOL valid;
@property (nonatomic) NSInteger numTimesLoggedIn;

@property (copy, nonatomic, readonly, nullable) NSString *anonymousCustomerServiceID;

- (instancetype)initWithObjectID:(nullable NSString *)objectID familyID:(nullable NSString *)familyID title:(nullable NSString *)title firstName:(nullable NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(nullable NSString *)lastName suffix:(nullable NSString *)suffix email:(NSString *)email avatar:(nullable LEOS3Image *)avatar phoneNumber:(nullable NSString *)phoneNumber insurancePlan:(nullable InsurancePlan *)insurancePlan primary:(BOOL)primary membershipType:(MembershipType)membershipType;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;
- (instancetype)initFromUserDefaults;

+ (NSDictionary *)dictionaryFromUser:(Guardian *)guardian;

- (void)incrementLoginCounter;
- (void)saveToUserDefaults;
+ (void)removeFromUserDefaults;
- (void)resetAnonymousCustomerServiceID;

NS_ASSUME_NONNULL_END
@end

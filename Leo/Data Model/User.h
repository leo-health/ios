//
//  User.h
//  Leo
//
//  Created by Zachary Drossman on 6/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Appointment, ConversationParticipant, Role;

@interface User : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, strong, nullable) NSDate * createdAt;
@property (nonatomic, strong, nullable) NSString * credentialSuffix;
@property (nonatomic, strong, nullable) NSDate * dob;
@property (nonatomic, strong, nullable) NSString * email;
@property (nonatomic, strong, nullable) NSString * familyID;
@property (nonatomic, strong) NSString * firstName;
@property (nonatomic, strong) NSString * gender;
@property (nonatomic, strong, nullable) NSString * id;
@property (nonatomic, strong) NSString * lastName;
@property (nonatomic, strong) NSString * middleInitial;
@property (nonatomic, strong, nullable) NSString * practiceID;
@property (nonatomic, strong, nullable) NSString * suffix;
@property (nonatomic, strong, nullable) NSString * title;
@property (nonatomic, strong, nullable) NSDate * updatedAt;
@property (nonatomic, strong, nullable) NSArray *appointments;
@property (nonatomic, strong) Role *role;

- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName dob:(nullable NSDate *)dob email:(nullable NSString*)email role:(Role *)role familyID:(nullable NSString *)familyID;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

- (NSDictionary *)dictionaryFromUser:(User*)user;

-(nullable NSString *)usernameFromID:(NSString *)id;
-(nullable NSString *)userroleFromID:(NSString *)id;

NS_ASSUME_NONNULL_END
@end

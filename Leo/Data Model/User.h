//
//  User.h
//  Leo
//
//  Created by Zachary Drossman on 6/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LEOS3Image.h"
@class Appointment, ConversationParticipant, Role;

@interface User : NSObject

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, copy, nullable) NSString * objectID;
@property (nonatomic, copy) NSString * firstName;
@property (nonatomic, copy) NSString * lastName;
@property (nonatomic, copy, nullable) NSString * middleInitial;
@property (nonatomic, copy, nullable) NSString * suffix;
@property (nonatomic, copy, nullable) NSString * title;
@property (nonatomic, copy, nullable) NSString *email;
@property (nonatomic, strong, nullable) LEOS3Image *avatar;

//- (instancetype)init MSDesignatedInitializer(initWithObjectID:title:firstName:middleInitial:lastName:suffix:email:avatar:);
//- (instancetype)new MSDesignatedInitializer(initWithObjectID:title:firstName:middleInitial:lastName:suffix:email:avatar:);

- (instancetype)initWithObjectID:(nullable NSString*)objectID title:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(NSString *)email avatar:(nullable LEOS3Image *)avatar NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

+ (NSDictionary *)dictionaryFromUser:(User*)user;
+ (NSDictionary *)plistFromUser:(User *)user;

- (NSString *)fullName;
- (NSString *)firstAndLastName;
- (NSString *)initials;

NS_ASSUME_NONNULL_END
@end

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



@interface User : NSObject <NSCoding>
NS_ASSUME_NONNULL_BEGIN



@property (nonatomic, copy, nullable) NSString * objectID;
@property (nonatomic, copy) NSString * firstName;
@property (nonatomic, copy) NSString * lastName;
@property (nonatomic, copy) NSString * middleInitial;
@property (nonatomic, copy, nullable) NSString * suffix;
@property (nonatomic, copy, nullable) NSString * title;
@property (nonatomic, copy, nullable) NSString *email;
@property (nonatomic, copy, nullable) NSString *avatarURL;
@property (nonatomic, strong, nullable) UIImage *avatar;

- (instancetype)initWithObjectID:(nullable NSString*)objectID title:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(NSString *)email avatarURL:(NSString *)avatarURL avatar:(nullable UIImage *)avatar NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;
- (void)updateWithJSONDictionary:(NSDictionary *)jsonResponse;

+ (NSDictionary *)dictionaryFromUser:(User*)user;

- (NSString *)fullName;
- (NSString *)firstAndLastName;

NS_ASSUME_NONNULL_END
@end

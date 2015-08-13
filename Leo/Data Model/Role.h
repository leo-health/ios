//
//  Role.h
//  Leo
//
//  Created by Zachary Drossman on 5/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//


/// MARK: This class likely will not be used. Will remove in a separate commit at a later time if appropriate.
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

typedef enum RoleType : NSUInteger {
    RoleTypeChild,
    RoleTypeParent,
    RoleTypeCaretaker,
    RoleTypeDoctor,
    RoleTypeNursePractitioner,
    RoleTypeAdministrator
} RoleType;

@interface Role : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, strong) NSDate * createdAt;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * resourceID;
@property (nonatomic, strong) NSDate * updatedAt;
@property (nonatomic, strong) User *user;

- (instancetype)initWithName:(NSString *)name resourceID:(NSString *)resourceID;
- (RoleType)roleType;


NS_ASSUME_NONNULL_END
@end

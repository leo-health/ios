//
//  UserRole.h
//  Leo
//
//  Created by Zachary Drossman on 5/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Role, User;

@interface UserRole : NSManagedObject

@property (nonatomic, retain) NSString * roleID;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) Role *role;
@property (nonatomic, retain) User *user;

@end

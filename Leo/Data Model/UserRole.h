//
//  UserRole.h
//  
//
//  Created by Zachary Drossman on 5/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Role, User;

@interface UserRole : NSManagedObject

@property (nonatomic, retain) NSNumber * roleID;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) Role *role;
@property (nonatomic, retain) User *user;

@end

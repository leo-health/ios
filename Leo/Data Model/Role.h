//
//  Role.h
//  Leo
//
//  Created by Zachary Drossman on 5/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserRole;

@interface Role : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * resourceID;
@property (nonatomic, retain) NSNumber * resourceType;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *userrole;
@end

@interface Role (CoreDataGeneratedAccessors)

- (void)addUserroleObject:(UserRole *)value;
- (void)removeUserroleObject:(UserRole *)value;
- (void)addUserrole:(NSSet *)values;
- (void)removeUserrole:(NSSet *)values;

@end

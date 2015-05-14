//
//  Role.h
//  
//
//  Created by Zachary Drossman on 5/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserRole;

@interface Role : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * resourceID;
@property (nonatomic, retain) NSString * resourceType;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) UserRole *userrole;

@end

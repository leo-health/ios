//
//  Role.h
//  Leo
//
//  Created by Zachary Drossman on 5/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Role : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * resourceID;
@property (nonatomic, retain) NSNumber * resourceType;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) User *user;

@end

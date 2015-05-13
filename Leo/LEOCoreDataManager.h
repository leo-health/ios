//
//  LEOCoreDataManager.h
//  
//
//  Created by Zachary Drossman on 5/11/15.
//
//

#import <Foundation/Foundation.h>
@import CoreData;
@class User;
@class LEOApiClient;

@interface LEOCoreDataManager : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *cards;
@property (strong, nonatomic) User *currentUser;

- (void)prepopulateData;
+ (instancetype)sharedManager;

@end

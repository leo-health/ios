//
//  PatientNote.h
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface PatientNote : NSObject

NS_ASSUME_NONNULL_BEGIN

@property (copy, nonatomic) NSString *objectID;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *updatedAt;
@property (strong, nonatomic) NSDate *deletedAt;
@property (copy, nonatomic) NSString *note;

-(instancetype)initWithObjectID:(NSString *)objectID user:(User *)user createdAt:(NSDate *)createdAt updatedAt:(NSDate *)updatedAt deletedAt:(NSDate *)deletedAt note:(NSString *)note;
-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary;
+(NSArray *)patientNotesFromDictionaries:(NSArray *)dictionaries;
+(instancetype)mockObject;

NS_ASSUME_NONNULL_END


@end

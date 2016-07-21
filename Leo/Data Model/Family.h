//
//  Family.h
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Patient;
@class Guardian;

@interface Family : NSObject <NSCoding>
NS_ASSUME_NONNULL_BEGIN

@property (copy, nonatomic, nullable) NSString *objectID;
@property (copy, nonatomic) NSArray *guardians;
@property (copy, nonatomic) NSArray *patients;

@property (strong, nonatomic) NSDate *updatedAtRemote;
@property (strong, nonatomic) NSDate *updatedAtLocal;
@property (nonatomic) BOOL shouldSyncUp;
@property (nonatomic) BOOL shouldSyncDown;

- (BOOL)isAheadOfRemote;
- (BOOL)isBehindRemote;

- (instancetype)initWithObjectID:(nullable NSString *)objectID guardians:(NSArray *)guardians patients:(NSArray *)patients;
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

+ (NSDictionary *)dictionaryWithPrimaryUserAndInsuranceOnlyFromFamily:(Family *)family;

- (void)addPatient:(Patient *)patient;
- (void)addGuardian:(Guardian *)guardian;

NS_ASSUME_NONNULL_END
@end

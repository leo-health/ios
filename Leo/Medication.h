//
//  Medication.h
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Medication : NSObject

NS_ASSUME_NONNULL_BEGIN

@property (strong, nonatomic) NSDate *startedAt;
@property (strong, nonatomic) NSDate *enteredAt;
@property (copy, nonatomic) NSString *medication;
@property (copy, nonatomic) NSString *sig;
@property (copy, nonatomic) NSString *note;
@property (copy, nonatomic) NSString *dose;
@property (copy, nonatomic) NSString *route;
@property (copy, nonatomic) NSString *frequency;

-(instancetype)initWithStartedAt:(NSDate *)startedAt enteredAt:(NSDate *)enteredAt medication:(NSString *)medication sig:(NSString *)sig note:(NSString *)note dose:(NSString *)dose route:(NSString *)route frequency:(NSString *)frequency;
-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary;
+(NSArray *)medicationsFromDictionaries:(NSArray *)dictionaries;
+(instancetype)mockObject;

NS_ASSUME_NONNULL_END


@end

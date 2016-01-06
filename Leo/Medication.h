//
//  Medication.h
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Medication : NSObject

@property (strong, nonatomic) NSDate *startedAt;
@property (strong, nonatomic) NSDate *enteredAt;
@property (strong, nonatomic) NSString *medication;
@property (strong, nonatomic) NSString *sig;
@property (strong, nonatomic) NSString *note;
@property (strong, nonatomic) NSString *dose;
@property (strong, nonatomic) NSString *route;
@property (strong, nonatomic) NSString *frequency;

-(instancetype)initWithStartedAt:(NSDate *)startedAt enteredAt:(NSDate *)enteredAt medication:(NSString *)medication sig:(NSString *)sig note:(NSString *)note dose:(NSString *)dose route:(NSString *)route frequency:(NSString *)frequency;
-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary;


@end

//
//  Allergy.h
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Allergy : NSObject

@property (strong, nonatomic) NSDate *onsetAt;
@property (strong, nonatomic) NSString *allergen;
@property (strong, nonatomic) NSString *severity;
@property (strong, nonatomic) NSString *note;

-(instancetype)initWithOnsetAt:(NSDate *)onsetAt allergen:(NSString *)allergen severity:(NSString *)severity note:(NSString *)note;
-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary;


@end

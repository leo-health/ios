//
//  Allergy.h
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Allergy : NSObject

NS_ASSUME_NONNULL_BEGIN

@property (strong, nonatomic) NSDate *onsetAt;
@property (copy, nonatomic) NSString *allergen;
@property (copy, nonatomic) NSString *severity;
@property (copy, nonatomic) NSString *note;

-(instancetype)initWithOnsetAt:(NSDate *)onsetAt allergen:(NSString *)allergen severity:(NSString *)severity note:(NSString *)note;
-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary;
+(NSArray *)allergiesFromDictionaries:(NSArray *)dictionaries;

NS_ASSUME_NONNULL_END
@end

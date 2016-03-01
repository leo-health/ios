//
//  Immunization.h
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Immunization : NSObject

NS_ASSUME_NONNULL_BEGIN

@property (strong, nonatomic) NSDate *administeredAt;
@property (copy, nonatomic) NSString *vaccine;

-(instancetype)initWithAdministeredAt:(NSDate *)administeredAt vaccine:(NSString *)vaccine;
-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary;
+(NSArray *)immunizationsFromDictionaries:(NSArray *)dictionaries;


NS_ASSUME_NONNULL_END
@end

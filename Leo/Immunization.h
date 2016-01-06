//
//  Immunization.h
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Immunization : NSObject

@property (strong, nonatomic) NSDate *administeredAt;
@property (strong, nonatomic) NSString *vaccine;

-(instancetype)initWithAdministeredAt:(NSDate *)administeredAt vaccine:(NSString *)vaccine;
-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@end

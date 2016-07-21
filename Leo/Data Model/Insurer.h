//
//  Insurer.h
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Insurer : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *objectID;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *fax;
@property (strong, nonatomic) NSArray *plans;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@end

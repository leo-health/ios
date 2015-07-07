//
//  Family.h
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Patient;
@class Caretaker;

@interface Family : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (copy, nonatomic) NSString *objectID;
@property (strong, nonatomic) NSArray *caretakers;
@property (strong, nonatomic) NSArray *children;

- (instancetype)initWithObjectID:(NSString *)id caretakers:(NSArray *)caregivers children:(NSArray *)children;
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

- (void)addChild:(Patient *)child;
- (void)addCaretaker:(Caretaker *)caretaker;

NS_ASSUME_NONNULL_END
@end

//
//  LEOCardService.h
//  Leo
//
//  Created by Zachary Drossman on 9/21/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOCardService : NSObject

- (void)getCardsWithCompletion:(void (^)(NSArray *cards, NSError *error))completionBlock;
- (void)deleteCardWithID:(NSString *)objectID completion:(void (^)(NSError *error))completionBlock;

@end

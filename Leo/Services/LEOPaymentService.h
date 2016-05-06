//
//  LEOPaymentService.h
//  Leo
//
//  Created by Zachary Drossman on 5/3/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

@class User;

#import <Stripe.h>
#import <Foundation/Foundation.h>

@interface LEOPaymentService : NSObject

- (NSURLSessionTask *)createChargeWithToken:(STPToken *)token
                   completion:(void (^)(BOOL success, NSError *error))completionBlock;

@end

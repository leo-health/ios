//
//  LEOFamilyService.m
//  Leo
//
//  Created by Adam Fanslau on 6/29/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOFamilyService.h"
#import "LEOPromise.h"
#import "Family.h"

@implementation LEOFamilyService

- (Family *)getFamily {
    return [[Family alloc] initWithJSONDictionary:[self.cachedService get:APIEndpointFamily params:nil]];
}

- (LEOPromise *)getFamilyWithCompletion:(void (^)(Family *family, NSError *error))completionBlock {

    return [self.cachedService get:APIEndpointFamily params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        Family *family = [[Family alloc] initWithJSONDictionary:rawResults];

        if (completionBlock) {
            completionBlock(family, error);
        }
    }];
}

@end

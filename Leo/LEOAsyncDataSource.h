//
//  LEOAsyncDataSource.h
//  Leo
//
//  Created by Adam Fanslau on 7/5/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOPromise.h"

@protocol LEOAsyncDataSource <NSObject>

- (LEOPromise *)get:(NSString*)endpoint params:(NSDictionary*)params completion:(LEODictionaryErrorBlock)completion;
- (LEOPromise *)put:(NSString*)endpoint params:(NSDictionary*)params completion:(LEODictionaryErrorBlock)completion;
- (LEOPromise *)post:(NSString*)endpoint params:(NSDictionary*)params completion:(LEODictionaryErrorBlock)completion;
- (LEOPromise *)destroy:(NSString *)endpoint params:(NSDictionary*)params completion:(LEODictionaryErrorBlock)completion;

@end

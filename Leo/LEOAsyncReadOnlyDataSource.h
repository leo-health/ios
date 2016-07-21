//
//  LEOAsyncReadOnlyDataSource.h
//  Leo
//
//  Created by Adam Fanslau on 7/21/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOPromise.h"

@protocol LEOAsyncReadOnlyDataSource <NSObject>

- (LEOPromise *)get:(NSString*)endpoint params:(NSDictionary*)params completion:(LEODictionaryErrorBlock)completion;

@end

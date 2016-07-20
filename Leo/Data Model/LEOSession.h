//
//  LEOSession.h
//  Leo
//
//  Created by Zachary Drossman on 5/18/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOCachedDataStore.h"
#import "Guardian.h"

@class LEODevice;

@interface LEOSession : NSObject

+ (NSDictionary *)serializeToJSON;

@end

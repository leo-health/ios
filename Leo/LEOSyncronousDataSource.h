//
//  LEOSyncronousDataSource.h
//  Leo
//
//  Created by Adam Fanslau on 7/5/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LEOSyncronousDataSource <NSObject>

- (NSDictionary *)get:(NSString*)endpoint params:(NSDictionary*)params;
- (NSDictionary *)put:(NSString*)endpoint params:(NSDictionary*)params;
- (NSDictionary *)post:(NSString*)endpoint params:(NSDictionary*)params;
- (NSDictionary *)destroy:(NSString*)endpoint params:(NSDictionary*)params;

@end

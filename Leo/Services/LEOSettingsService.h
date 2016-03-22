//
//  LEOSettingsService.h
//  Leo
//
//  Created by Zachary Drossman on 3/21/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOSettingsService : NSObject

- (void)getConfigurationWithCompletion:(void (^)(BOOL success, NSError *error))completionBlock;

@end

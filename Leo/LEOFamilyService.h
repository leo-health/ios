//
//  LEOFamilyService.h
//  Leo
//
//  Created by Adam Fanslau on 6/29/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOModelService.h"

@class Family;

@interface LEOFamilyService : LEOModelService

- (Family *)getFamily;

- (LEOPromise *)getFamilyWithCompletion:(void (^)(Family *family, NSError *error))completionBlock;

- (LEOPromise *)putFamily:(Family *)family withCompletion:(void (^)(Family *family, NSError *error))completionBlock;

@end

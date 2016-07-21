//
//  LEOUserService.h
//  Leo
//
//  Created by Zachary Drossman on 9/21/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class User, Guardian, Family, Patient;

#import <Foundation/Foundation.h>
#import "LEOModelService.h"
#import "LEOUserDataSource.h"

@interface LEOUserService : LEOModelService <LEOUserDataSource>

@end

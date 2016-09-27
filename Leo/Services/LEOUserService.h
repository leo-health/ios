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

//FIXME: ZSD - LEOUserDataSource conformance allows us to not declare the methods that have been defined in the .m. This is so that a view controller can act as the datasource instead of the LEOUserService. However, we should think on how to implement this such that this is self-explanatory.
@end

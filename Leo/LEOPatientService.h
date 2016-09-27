//
//  LEOPatientService.h
//  Leo
//
//  Created by Adam Fanslau on 6/30/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOModelService.h"
#import "LEOCachePolicy.h"
#import "LEOPatientDataSource.h"

@interface LEOPatientService : LEOModelService <LEOPatientDataSource>

//FIXME: ZSD - LEOPatientDataSource conformance allows us to not declare the methods that have been defined in the .m. This is so that a view controller can act as the datasource instead of the LEOPatientService. However, we should think on how to implement this such that this is self-explanatory.
@end

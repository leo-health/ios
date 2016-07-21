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

@end

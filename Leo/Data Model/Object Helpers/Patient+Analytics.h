//
//  Patient+Analytics.h
//  Leo
//
//  Created by Annie Graham on 7/1/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "Patient.h"

@interface Patient (Analytics)

/**
 *  Returns analytic attributes of a patient.
 *
 *  @return Dictionary of patient analytic attributes.
 */
- (NSDictionary *)analyticAttributes;


@end

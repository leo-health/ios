//
//  Guardian+Analytics.h
//  Leo
//
//  Created by Annie Graham on 6/21/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "Guardian.h"

@interface Guardian (Analytics)

- (NSString *)isPrimaryString;
- (NSString *)membershipTypeString;
- (NSDictionary *)attributes;

@end

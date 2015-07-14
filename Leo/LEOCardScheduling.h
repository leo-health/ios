//
//  LEOCardScheduling.h
//  Leo
//
//  Created by Zachary Drossman on 5/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOCard.h"

@interface LEOCardScheduling : LEOCard

- (instancetype)initWithDictionary:(NSDictionary *)jsonCard;

@end
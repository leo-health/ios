//
//  LEOChildCell+ConfigureForCell.h
//  Leo
//
//  Created by Zachary Drossman on 6/13/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOChildCell.h"
@class User;

@interface LEOChildCell (ConfigureForCell)

- (void)configureForChild:(User *)child;

@end

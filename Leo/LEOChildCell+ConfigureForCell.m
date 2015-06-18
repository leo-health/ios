//
//  LEOChildCell+ConfigureForCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/13/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOChildCell+ConfigureForCell.h"
#import "User.h"

@implementation LEOChildCell (ConfigureForCell)

- (void)configureForChild:(User *)child {
    
    self.nameLabel.text = child.firstName;
}

@end

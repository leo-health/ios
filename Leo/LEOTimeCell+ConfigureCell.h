//
//  LEOTimeCell+ConfigureCell.h
//  Leo
//
//  Created by Zachary Drossman on 6/6/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOTimeCell.h"

@class Slot;

@interface LEOTimeCell (ConfigureCell)

- (void)configureForSlot:(Slot *)slot;

@end

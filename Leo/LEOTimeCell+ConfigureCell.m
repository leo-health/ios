//
//  LEOTimeCell+ConfigureCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/6/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOTimeCell+ConfigureCell.h"
#import "NSDate+Extensions.h"
#import "Slot.h"

@implementation LEOTimeCell (ConfigureCell)

- (void)configureForSlot:(Slot *)slot {
    
    self.timeLabel.text = [NSDate stringifiedTime:slot.startDateTime];
    self.selected = NO;
}

@end

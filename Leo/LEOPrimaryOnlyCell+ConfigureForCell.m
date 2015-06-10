//
//  LEOPrimaryOnlyCell+ConfigureForCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/10/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOPrimaryOnlyCell+ConfigureForCell.h"

@implementation LEOPrimaryOnlyCell (ConfigureForCell)


- (void)configureForCard:(Card *)card
{
    self.photoTitleLabel.text = photo.name;
    self.photoDateLabel.text = [self.dateFormatter stringFromDate:photo.creationDate];
}

@end

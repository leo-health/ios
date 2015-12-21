//
//  LEOPrimaryOnlyCell+ConfigureForCell.h
//  Leo
//
//  Created by Zachary Drossman on 6/10/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOTwoButtonPrimaryOnlyCell.h"

@class LEOCard;

@interface LEOTwoButtonPrimaryOnlyCell (ConfigureForCell) 

- (void)configureForCard:(id<LEOCardProtocol>)card;

@end

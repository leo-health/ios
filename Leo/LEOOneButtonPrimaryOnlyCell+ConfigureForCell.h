//
//  LEOOneButtonPrimaryOnlyCell+ConfigureForCell.h
//  Leo
//
//  Created by Zachary Drossman on 6/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOOneButtonPrimaryOnlyCell.h"
@class LEOCard;

@interface LEOOneButtonPrimaryOnlyCell (ConfigureForCell)

- (void)configureForCard:(id<LEOCardProtocol>)card;

@end

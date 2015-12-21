//
//  LEOOneButtonSecondaryOnlyCell+ConfigureForCell.h
//  Leo
//
//  Created by Zachary Drossman on 6/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOOneButtonSecondaryOnlyCell.h"
@class LEOCard;

@interface LEOOneButtonSecondaryOnlyCell (ConfigureForCell)

- (void)configureForCard:(id<LEOCardProtocol>)card;

@end

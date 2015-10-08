//
//  LEOReviewUserCell+ConfigureForCell.h
//  Leo
//
//  Created by Zachary Drossman on 10/5/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class Guardian;

#import "LEOReviewUserCell.h"

@interface LEOReviewUserCell (ConfigureForCell)

- (void)configureForGuardian:(Guardian *)guardian;

@end

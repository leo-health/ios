//
//  ReviewUserCell+ConfigureForCell.h
//  Leo
//
//  Created by Zachary Drossman on 10/5/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class Guardian;

#import "ReviewUserCell.h"

@interface ReviewUserCell (ConfigureForCell)

- (void)configureForGuardian:(Guardian *)guardian;

@end

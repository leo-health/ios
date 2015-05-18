//
//  LEOCardCellTableViewCell.h
//  Leo
//
//  Created by Zachary Drossman on 5/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOCard.h"

@interface LEOCardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet LEOCard *cardView;

@end

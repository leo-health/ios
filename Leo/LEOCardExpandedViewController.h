//
//  LEOCardExpandedViewController.h
//  Leo
//
//  Created by Zachary Drossman on 7/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOCard.h"

@interface LEOCardExpandedViewController : UIViewController

@property (strong, nonatomic) LEOCard *card;
@property (strong, nonatomic) UITableViewCell *collapsedCell;

@end
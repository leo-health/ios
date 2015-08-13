//
//  LEOCardExpandedViewController.h
//  Leo
//
//  Created by Zachary Drossman on 7/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOCard.h"

/**
 *  Abstract view controller for expanded card view
 */
@interface LEOCardExpandedViewController : UIViewController

@property (strong, nonatomic) LEOCard *card;
@property (strong, nonatomic) UIButton *dismissButton;

- (UIImage *)iconImage;
- (void)button0Tapped;
- (void)button1Tapped;

@end
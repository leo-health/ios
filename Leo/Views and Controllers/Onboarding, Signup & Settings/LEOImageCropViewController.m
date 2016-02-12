//
//  LEOImageCropViewController.m
//  Leo
//
//  Created by Zachary Drossman on 12/2/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOImageCropViewController.h"
#import "UIImage+Extensions.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "LEOStyleHelper.h"

@implementation LEOImageCropViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.moveAndScaleLabel.hidden = YES;
    self.chooseButton.hidden = YES;
    self.cancelButton.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    // RSKImageCropViewController feels it has the right to hide the nav bar, so we need to unhide it here
    self.navigationController.navigationBarHidden = NO;

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}


@end

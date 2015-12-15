//
//  LEOImageCropViewController.m
//  Leo
//
//  Created by Zachary Drossman on 12/2/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOImageCropViewController.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
@interface LEOImageCropViewController ()

@end

@implementation LEOImageCropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        self.moveAndScaleLabel.font = [UIFont leo_standardFont];
        self.moveAndScaleLabel.textColor = [UIColor leo_orangeRed];
        self.maskLayerColor = [UIColor leo_white];
        [self.cancelButton setTitleColor:[UIColor leo_orangeRed] forState:UIControlStateNormal];
        [self.chooseButton setTitleColor:[UIColor leo_orangeRed] forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font = [UIFont leo_standardFont];
        self.chooseButton.titleLabel.font = [UIFont leo_standardFont];
        self.avoidEmptySpaceAroundImage = YES;
        self.view.backgroundColor = [UIColor leo_white];
}


@end

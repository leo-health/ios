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
#import "LEOStyleHelper.h"

@interface LEOImageCropViewController ()

@end

@implementation LEOImageCropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        self.moveAndScaleLabel.font = [UIFont leo_standardFont];
        self.moveAndScaleLabel.textColor = self.view.tintColor;
        self.maskLayerColor = [UIColor leo_white];
        [self.cancelButton setTitleColor:[LEOStyleHelper tintColorForFeature:self.feature] forState:UIControlStateNormal];
        [self.chooseButton setTitleColor:[LEOStyleHelper tintColorForFeature:self.feature] forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font = [UIFont leo_standardFont];
        self.chooseButton.titleLabel.font = [UIFont leo_standardFont];
        self.view.backgroundColor = [UIColor leo_white];
}


@end

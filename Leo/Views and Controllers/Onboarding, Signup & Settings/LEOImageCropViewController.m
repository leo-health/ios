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
    
        self.moveAndScaleLabel.font = [UIFont leoStandardFont];
        self.moveAndScaleLabel.textColor = [UIColor leoOrangeRed];
        self.maskLayerColor = [UIColor leoWhite];
        [self.cancelButton setTitleColor:[UIColor leoOrangeRed] forState:UIControlStateNormal];
        [self.chooseButton setTitleColor:[UIColor leoOrangeRed] forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font = [UIFont leoStandardFont];
        self.chooseButton.titleLabel.font = [UIFont leoStandardFont];
        self.avoidEmptySpaceAroundImage = YES;
        self.view.backgroundColor = [UIColor leoWhite];
}


@end

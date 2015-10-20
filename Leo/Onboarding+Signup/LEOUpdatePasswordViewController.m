//
//  LEOUpdatePasswordViewController.m
//  Leo
//
//  Created by Zachary Drossman on 10/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOUpdatePasswordViewController.h"
#import "LEOStyleHelper.h"
#import "LEOUpdatePasswordView.h"

@interface LEOUpdatePasswordViewController ()

@property (weak, nonatomic) IBOutlet LEOUpdatePasswordView *updatePasswordView;
@property (weak, nonatomic) IBOutlet UIButton *updatePasswordButton;


@end

@implementation LEOUpdatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self setupButton];
    [self setupNavigationBar];
}

- (void)setupView {
    
    [LEOStyleHelper styleViewForSettings:self.view];
}

- (void)setupButton {
    
    [self.updatePasswordButton addTarget:self action:@selector(updatePasswordTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupNavigationBar {
    
    self.navigationItem.title = @"Change password";
    
    [LEOStyleHelper styleCustomBackButtonForViewController:self];
}

- (void)updatePasswordTapped {
    
    if ([self.updatePasswordView isValidPassword]) {
        
        [self.updatePasswordView isValidCurrentPassword:YES];
        NSLog(@"Password updated!");
    }
}

- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end

//
//  LEOUpdateEmailViewController.m
//  Leo
//
//  Created by Zachary Drossman on 10/12/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOUpdateEmailViewController.h"
#import "LEOStyleHelper.h"
#import "LEOUpdateEmailView.h"

@interface LEOUpdateEmailViewController ()

@property (weak, nonatomic) IBOutlet LEOUpdateEmailView *updateEmailView;
@property (weak, nonatomic) IBOutlet UIButton *updateEmailButton;

@end

@implementation LEOUpdateEmailViewController

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
    
    [self.updateEmailButton addTarget:self action:@selector(updateEmailTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupNavigationBar {
    
    self.navigationItem.title = @"Update Email";
    
    [LEOStyleHelper styleCustomBackButtonForViewController:self];
}

- (void)updateEmailTapped {
    
    if ([self.updateEmailView isValidEmail]) {
        
        NSLog(@"Email updated!");
    }
}

- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end

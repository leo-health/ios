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
    
    [LEOStyleHelper tintColorForFeature:FeatureSettings];
    
    UITapGestureRecognizer *tapGestureForTextFieldDismissal = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewWasTapped)];
    tapGestureForTextFieldDismissal.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureForTextFieldDismissal];
}

- (void)viewWasTapped {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)setupButton {
    
    [self.updateEmailButton addTarget:self action:@selector(updateEmailTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupNavigationBar {
    
    self.view.tintColor = [LEOStyleHelper tintColorForFeature:FeatureSettings];
    
    [LEOStyleHelper styleNavigationBarForFeature:FeatureSettings];
    
    UILabel *navTitleLabel = [[UILabel alloc] init];
    navTitleLabel.text = @"Update Email";
    
    [LEOStyleHelper styleLabel:navTitleLabel forFeature:FeatureSettings];
    
    self.navigationItem.titleView = navTitleLabel;
    
    [LEOStyleHelper styleBackButtonForViewController:self];
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

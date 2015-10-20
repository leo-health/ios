//
//  LEOInviteViewController.m
//  Leo
//
//  Created by Zachary Drossman on 10/9/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOInviteViewController.h"
#import "LEOStyleHelper.h"
#import "LEOValidationsHelper.h"
#import "LEOInviteView.h"

@interface LEOInviteViewController ()

@property (weak, nonatomic) IBOutlet LEOInviteView *inviteView;
@property (weak, nonatomic) IBOutlet UIButton *sendInvitationsButton;

@end

@implementation LEOInviteViewController

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
    
    [self.sendInvitationsButton addTarget:self action:@selector(sendInvitationsTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupNavigationBar {
    
    self.navigationItem.title = @"Invite a Parent";
    
    [LEOStyleHelper styleCustomBackButtonForViewController:self];
}

- (void)sendInvitationsTapped {
    
    if ([self.inviteView isValidInvite]) {
        
        NSLog(@"Invite sent!");
    }
}

- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end

//
//  LEOInitialViewController.m
//  Leo
//
//  Created by Zachary Drossman on 8/31/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOInitialViewController.h"
#import "UIImage+Extensions.h"
#import "LEOHorizontalModalTransitioningDelegate.h"

static NSString *const kLoginSegue = @"LoginSegue";
static NSString *const kSignUpSegue = @"SignUpSegue";

@interface LEOInitialViewController()

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) LEOHorizontalModalTransitioningDelegate *transitioningDelegate;
@end

@implementation LEOInitialViewController


-(void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
#if AUTOLOGIN_FLAG
    [self loginTapped:nil];
#endif
}


- (IBAction)loginTapped:(UIButton *)sender {
    [self performSegueWithIdentifier:kLoginSegue sender:sender];
}

- (IBAction)signUpTapped:(UIButton *)sender {
    [self performSegueWithIdentifier:kSignUpSegue sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *navController = segue.destinationViewController;
    
    self.transitioningDelegate = [[LEOHorizontalModalTransitioningDelegate alloc] init];

    navController.transitioningDelegate = self.transitioningDelegate;
    navController.modalPresentationStyle = UIModalPresentationCustom;
}
@end

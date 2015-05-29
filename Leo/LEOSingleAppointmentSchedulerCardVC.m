//
//  LEOSingleAppointmentSchedulerCardVC.m
//  Leo
//
//  Created by Zachary Drossman on 5/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOSingleAppointmentSchedulerCardVC.h"

@interface LEOSingleAppointmentSchedulerCardVC ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation LEOSingleAppointmentSchedulerCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    
//    [self.contentView removeConstraints:self.contentView.constraints];
//    self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:300];
//    
//    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:300];
//    
//    [self.contentView addConstraints:@[widthConstraint,heightConstraint]];
//    [self.contentView setNeedsLayout];
}

- (IBAction)cancelTapped:(UIButton *)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [UIView animateWithDuration:0.2 animations:^{
        self.collapsedCell.layer.transform = CATransform3DMakeRotation(0,0.0,1.0,0.0); ; //flip halfway
            self.collapsedCell.selected = NO;
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

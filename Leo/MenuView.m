//
//  MenuView.m
//  Leo
//
//  Created by Zachary Drossman on 6/23/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "MenuView.h"
#import "UIColor+LeoColors.h"

@interface MenuView ()

//TODO: This property can be removed once we add xibAdditions to this class (or at the very least made weak if we decide to hold onto it for some reason.)
@property (strong, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UIButton *scheduleAVisitLabelButton;
@property (weak, nonatomic) IBOutlet UIButton *submitAFormLabelButton;
@property (weak, nonatomic) IBOutlet UIButton *contactLeoLabelButton;

@end

@implementation MenuView

@synthesize scheduleAVisitLabelButton = _scheduleAVisitLabelButton;
@synthesize submitAFormLabelButton = _submitAFormLabelButton;
@synthesize contactLeoLabelButton = _contactLeoLabelButton;

#pragma mark - Accessors

- (void)setScheduleAVisitLabelButton:(UIButton *)scheduleAVisitLabelButton {
    
    _scheduleAVisitLabelButton = scheduleAVisitLabelButton;
    
    [_scheduleAVisitLabelButton setImage:[UIImage imageNamed:@"Menu-Scheduling"] forState:UIControlStateNormal];
    [_scheduleAVisitLabelButton setTitleColor:[UIColor leo_gray74] forState:UIControlStateNormal];
    _scheduleAVisitLabelButton.tintColor = [UIColor leo_green];
}

- (void)setSubmitAFormLabelButton:(UIButton *)submitAFormLabelButton {
    
    _submitAFormLabelButton = submitAFormLabelButton;
    
    [_submitAFormLabelButton setImage:[UIImage imageNamed:@"Menu-Forms"] forState:UIControlStateNormal];
    [_submitAFormLabelButton setTitleColor:[UIColor leo_gray74] forState:UIControlStateNormal];
    _submitAFormLabelButton.tintColor = [UIColor leo_purple];
}

- (void)setContactLeoLabelButton:(UIButton *)contactLeoLabelButton {
    
    _contactLeoLabelButton = contactLeoLabelButton;
    
    [_contactLeoLabelButton setImage:[UIImage imageNamed:@"Menu-Chat"] forState:UIControlStateNormal];
    [_contactLeoLabelButton setTitleColor:[UIColor leo_gray74] forState:UIControlStateNormal];
    _contactLeoLabelButton.tintColor = [UIColor leo_blue];
}


#pragma mark - Actions

- (IBAction)scheduleAVisitLabelTapped:(UIButton *)sender {
    [self.delegate didMakeMenuChoice:MenuChoiceScheduleAppointment];
}

- (IBAction)submitAFormLabelTapped:(UIButton *)sender {
    [self.delegate didMakeMenuChoice:MenuChoiceSubmitAForm];
}

- (IBAction)contactLeoLabelTapped:(UIButton *)sender {
    [self.delegate didMakeMenuChoice:MenuChoiceChat];
}


@end

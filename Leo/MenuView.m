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
@property (weak, nonatomic) IBOutlet UIButton *settingsLabelButton;

@end

@implementation MenuView

@synthesize scheduleAVisitLabelButton = _scheduleAVisitLabelButton;
@synthesize submitAFormLabelButton = _submitAFormLabelButton;
@synthesize contactLeoLabelButton = _contactLeoLabelButton;
@synthesize settingsLabelButton = _settingsLabelButton;

#pragma mark - Initialization

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if(self){
        [self commonInit];
    }
    
    return self;
}


//TODO: Both of the lines of code having to do with the view property should be replaced by the xibAdditions UIView category once it has been added to master. May remove commonInit altogether.
- (void)commonInit {
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                  owner:self
                                options:nil];
    
    [self addSubview:self.view];
}


#pragma mark - Accessors

- (void)setScheduleAVisitLabelButton:(UIButton *)scheduleAVisitLabelButton {
    
    _scheduleAVisitLabelButton = scheduleAVisitLabelButton;
    
    [_scheduleAVisitLabelButton setImage:[UIImage imageNamed:@"Menu-Scheduling"] forState:UIControlStateNormal];
    [_scheduleAVisitLabelButton setTitleColor:[UIColor leoGrayForTitlesAndHeadings] forState:UIControlStateNormal];
    _scheduleAVisitLabelButton.tintColor = [UIColor leoGreen];
}

- (void)setSubmitAFormLabelButton:(UIButton *)submitAFormLabelButton {
    
    _submitAFormLabelButton = submitAFormLabelButton;
    
    [_submitAFormLabelButton setImage:[UIImage imageNamed:@"Menu-Forms"] forState:UIControlStateNormal];
    [_submitAFormLabelButton setTitleColor:[UIColor leoGrayForTitlesAndHeadings] forState:UIControlStateNormal];
    _submitAFormLabelButton.tintColor = [UIColor leoPurple];
}

- (void)setContactLeoLabelButton:(UIButton *)contactLeoLabelButton {
    
    _contactLeoLabelButton = contactLeoLabelButton;
    
    [_contactLeoLabelButton setImage:[UIImage imageNamed:@"Menu-Chat"] forState:UIControlStateNormal];
    [_contactLeoLabelButton setTitleColor:[UIColor leoGrayForTitlesAndHeadings] forState:UIControlStateNormal];
    _contactLeoLabelButton.tintColor = [UIColor leoBlue];
}

- (void)setSettingsLabelButton:(UIButton *)settingsLabelButton {
    
    _settingsLabelButton = settingsLabelButton;
    
    [_settingsLabelButton setImage:[UIImage imageNamed:@"Menu-Settings"] forState:UIControlStateNormal];
    [_settingsLabelButton setTitleColor:[UIColor leoGrayForTitlesAndHeadings] forState:UIControlStateNormal];
    _settingsLabelButton.tintColor = [UIColor leoGrayForTimeStamps];
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

- (IBAction)settingsLabelTapped:(UIButton *)sender {
    [self.delegate didMakeMenuChoice:MenuChoiceUpdateSettings];
}


//TODO: This should be replaced by the xibAdditions UIView category once it has been added to master.
- (void)addSubview:(UIView *)view {
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [super addSubview:view];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:views]];
}


@end

//
//  MenuView.m
//  Leo
//
//  Created by Zachary Drossman on 6/23/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "MenuView.h"
#import "LEOCardScheduling.h"
#import "Appointment.h"

@interface MenuView ()

@property (strong, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UIButton *scheduleAVisitLabelButton;
@property (weak, nonatomic) IBOutlet UIButton *submitAFormLabelButton;
@property (weak, nonatomic) IBOutlet UIButton *contactLeoLabelButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsLabelButton;


@end


@implementation MenuView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if(self){
        [self commonInit];
    }
    
    return self;
}

/**
 *  CommonInit is used to provide access to initialization code relevant to any instantiation method (IB or code-based)
 */
- (void)commonInit {
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                  owner:self
                                options:nil];
    
    [self addSubview:self.view];
    
}


#pragma mark - Menu View Button Animation

/**
 *  Loads a SchedulingCardViewController
 *
 *  @param sender UIButton that receives tap gesture
 */
- (IBAction)scheduleAVisitLabelTapped:(UIButton *)sender {
    
    // Posting notification from another object
    [self.delegate didMakeMenuChoice];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"requestToBookNewAppointment"
                                                        object:self
                                                      userInfo:nil];
}

/**
 *  Loads a FormCardViewController
 *
 *  @param sender UIButton that receives tap gesture
 */
- (IBAction)submitAFormLabelTapped:(UIButton *)sender {
    [self.view removeFromSuperview];
}

/**
 *  Loads Leo contact information
 *
 *  @param sender UIButton that receives tap gesture
 */
- (IBAction)contactLeoLabelTapped:(UIButton *)sender {
    [self.view removeFromSuperview];
}

/**
 *  Loads SettingsCardViewController
 *
 *  @param sender UIButton that receives tap gesture
 */
- (IBAction)settingsLabelTapped:(UIButton *)sender {
    [self.view removeFromSuperview];
}

-(void)addSubview:(UIView *)view {
    
    
    /**
     *  Zachary Drossman
     *  Implementation of addSubview to ensure the MenuView is sized according to its subviews
     */
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [super addSubview:view];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:views]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

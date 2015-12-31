
//
//  LEOAppointmentViewController.m
//  Leo
//
//  Created by Zachary Drossman on 11/24/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#include "math.h"

#import "LEOAppointmentViewController.h"
#import "LEOAppointmentView.h"
#import "LEOCardAppointment.h"

#import "LEOStyleHelper.h"
#import "UIColor+LeoColors.h"
#import "UIImage+Layer.h"

#import "LEOCalendarViewController.h"
#import "LEOBasicSelectionViewController.h"

#import "AppointmentTypeCell+ConfigureCell.h"
#import "PatientCell+ConfigureCell.h"
#import "ProviderCell+ConfigureCell.h"

//TODO: Consider whether a factory initialization could or should remove these APIOperation subclasses from being imported into this class.
#import "LEOAPISlotsOperation.h"
#import "LEOAPIAppointmentTypesOperation.h"
#import "LEOAPIFamilyOperation.h"
#import "LEOAPIPracticeOperation.h"

#import "AppointmentType.h"
#import "Appointment.h"
#import "Patient.h"
#import "AppointmentStatus.h"

#import <MBProgressHUD.h>

#import "LEOGradientView.h"
#import "LEOAppointmentService.h"

static NSString *const kCopySubmitAppointment = @"CONFIRM VISIT";

// Appointment Segue constants
static NSString *const kVisitTypeSegue = @"VisitTypeSegue";
static NSString *const kAppointmentType = @"appointmentType";
static NSString *const kAppointmentTypeCell = @"AppointmentTypeCell";
static NSString *const kTypeOfVisitPrompt = @"What type of visit is this?";

// Patient segue constants
static NSString *const kPatientSegue = @"PatientSegue";
static NSString *const kSelectionVCPatientKey = @"patient";
static NSString *const kPatientCell = @"PatientCell";
static NSString *const kPatientPrompt = @"Who is the visit for?";

// Staff/Schedule segue constants
static NSString *const kStaffSegue = @"StaffSegue";
static NSString *const kSelectionVCProviderKey = @"provider";
static NSString *const kProviderCell = @"ProviderCell";
static NSString *const kProviderPrompt = @"Who would you like to see?";
static NSString *const kScheduleSegue = @"ScheduleSegue";
static NSString *const kSelectionVCDateKey = @"date";


@interface LEOAppointmentViewController ()

@property (weak, nonatomic) LEOAppointmentView *appointmentView;
@property (strong, nonatomic) LEOGradientView *gradientView;
@property (strong, nonatomic) UIButton *submissionButton;
@property (strong, nonatomic) Appointment *appointment;

@property (nonatomic) BOOL didLayoutSubviewsOnce;

@end

@implementation LEOAppointmentViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad {

    [super viewDidLoad];

    self.feature = FeatureAppointmentScheduling;

    [self setupNavigationBar];

    self.submissionButton.enabled = self.appointment.isValidForBooking;
    self.stickyHeaderView.snapToHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    __weak LEOAppointmentViewController* weakSelf = self;
    [self addAnimationToNavBar:^{
        [weakSelf.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        CGFloat percentage = [weakSelf transitionPercentageForScrollOffset:weakSelf.scrollViewContentOffset];
        weakSelf.navigationItem.titleView.hidden = percentage == 0;
    }];
    
    [self.view updateConstraints];
}

-(void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];

    // Match the gradient in consecutive nav bars
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.navigationController.navigationBar.bounds;
    gradient.colors = self.gradientView.colors;
    gradient.startPoint = CGPointMake(0,0);
    gradient.endPoint = CGPointMake(1, 1);

    __weak id weakSelf = self;
    void(^animations)() = ^(){
        [[weakSelf navigationController].navigationBar setBackgroundImage:[UIImage imageFromLayer:gradient] forBarMetrics:UIBarMetricsDefault];
    };

    if ([self.stickyHeaderView isCollapsed]) {
        animations();
    } else {
        [self addAnimationToNavBar:animations];
    }
}

-(void)setupNavigationBar {

    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:self.feature withTitleText:self.card.title dismissal:YES backButton:NO];
}


-(void)setCard:(LEOCardAppointment *)card {

    _card = card;
    _card.activityDelegate = self;

    self.stickyHeaderView.datasource = self;
    self.stickyHeaderView.delegate = self;
}

#pragma mark - Layout

- (CGFloat)translateRelativePosition:(CGFloat)relativePositionInitial fromSize:(CGFloat)initialSize toSize:(CGFloat)finalSize {

    // get absolute position
    CGFloat absolutePosI = relativePositionInitial * initialSize;
    // get extra size
    CGFloat extra = initialSize - finalSize;
    // subtract extra size
    CGFloat absolutePosF = absolutePosI - extra;
    // get relative position
    CGFloat relPos = absolutePosF / finalSize;

    return relPos;
}

/**
 *  Calculates the start and end points based on a center, rotation and radius 
 *  Returns both start and end points by passing the points by reference
 *
 *  @param startPoint a pointer to a CGPoint
 *  @param endPoint   a pointer to a CGPoint
 *  @param center     CGPoint representing the center of the circle
 *  @param r          radius
 *  @param theta      clockwise rotation in radians relative to x axis
 */
-(void)gradientStartPoint:(CGPoint*)startPoint endPoint:(CGPoint*)endPoint withCenter:(CGPoint)center withRadius:(CGFloat)r withRotationInRadians:(CGFloat)theta {

    CGFloat dy = r * sinf(theta);
    CGFloat dx = r * cosf(theta);
    *startPoint = CGPointMake(center.x - dx, center.y - dy);
    *endPoint = CGPointMake(center.x + dx, center.y + dy);
}

-(void)viewDidLayoutSubviews {

    [super viewDidLayoutSubviews];

    if (!self.didLayoutSubviewsOnce) {

        // To get an accurate angle for the gradient, place the start and end points on the edge a circle that is centered in the view
        CGFloat y2 = 1;
        CGFloat r = 0.05;
        CGPoint start;
        CGPoint end;

        CGRect rect = self.gradientView.bounds;
        CGFloat y1 = [self translateRelativePosition:0 fromSize:CGRectGetHeight(rect) toSize:CGRectGetHeight(self.gradientView.gradientLayerBounds)];
        CGPoint center = CGPointMake(0.5, y1 + (y2 - y1)/2);
        CGFloat theta = atanf(CGRectGetWidth(rect)/(CGRectGetHeight(rect)/2));
        [self gradientStartPoint:&start endPoint:&end withCenter:center withRadius:r withRotationInRadians:theta];

        self.gradientView.initialStartPoint = start;
        self.gradientView.initialEndPoint = end;

        rect = self.navigationController.navigationBar.bounds;
        y1 = [self translateRelativePosition:0 fromSize:CGRectGetHeight(rect) toSize:CGRectGetHeight(self.gradientView.gradientLayerBounds)];
        center = CGPointMake(0.5, y1 + (y2 - y1)/2);
        theta = atanf(CGRectGetWidth(rect)/(CGRectGetHeight(rect)/2));
        [self gradientStartPoint:&start endPoint:&end withCenter:center withRadius:r withRotationInRadians:theta];

        self.gradientView.finalStartPoint = start;
        self.gradientView.finalEndPoint = end;
        
        self.didLayoutSubviewsOnce = YES;
    }
}

#pragma mark - StickyHeaderView Delegate

-(UIView *)injectTitleView {
    return self.gradientView;
}

-(LEOGradientView *)gradientView {

    if (!_gradientView) {

        LEOGradientView *strongView = [LEOGradientView new];
        _gradientView = strongView;
        _gradientView.colors = @[(id)[UIColor leo_green].CGColor, (id)[UIColor leo_white].CGColor];
        _gradientView.titleText = self.card.title;

        NSNumber *_height = @150;
        NSArray *heightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_gradientView(==_height)]" options:0 metrics:NSDictionaryOfVariableBindings(_height) views:NSDictionaryOfVariableBindings(_gradientView)];
        [_gradientView addConstraints:heightConstraint];
    }

    return _gradientView;
}

-(UIView *)injectFooterView {
    return self.submissionButton;
}

-(UIButton *)submissionButton {

    if (!_submissionButton) {

        UIButton* strongButton = [UIButton new];
        _submissionButton = strongButton;

        [LEOStyleHelper styleSubmissionButton:_submissionButton forFeature:self.feature];
        [_submissionButton addTarget:self action:@selector(submitCardUpdates) forControlEvents:UIControlEventTouchUpInside];
        [_submissionButton setTitle:kCopySubmitAppointment forState:UIControlStateNormal];

        NSNumber *_height = @44;
        NSArray *heightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_submissionButton(==_height)]" options:0 metrics:NSDictionaryOfVariableBindings(_height) views:NSDictionaryOfVariableBindings(_submissionButton)];
        [_submissionButton addConstraints:heightConstraint];
    }

    return _submissionButton;
}

-(void)updateTitleViewForScrollTransitionPercentage:(CGFloat)transitionPercentage {

    self.gradientView.currentTransitionPercentage = transitionPercentage;
    self.navigationItem.titleView.hidden = NO;
    self.navigationItem.titleView.alpha = transitionPercentage;
}

- (UIView *)injectBodyView {

    LEOAppointmentView *strongView = self.appointmentView;

    strongView.delegate = self;
    strongView.tintColor = [LEOStyleHelper tintColorForFeature:FeatureAppointmentScheduling];

    return strongView;
}

-(LEOAppointmentView *)appointmentView {

    if (!_appointmentView) {

        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *class = NSStringFromClass([LEOAppointmentView class]);
        NSArray *loadedViews = [mainBundle loadNibNamed:class
                                                  owner:self
                                                options:nil];

        _appointmentView = [loadedViews firstObject];

        _appointmentView.appointment = self.appointment;
    }

    return _appointmentView;
}

-(Appointment *)appointment {
    return self.appointmentView.appointment;
}

-(void)leo_performSegueWithIdentifier:(NSString *)segueIdentifier {
    [self performSegueWithIdentifier:segueIdentifier sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    __block BOOL shouldSelect = NO;

    LEOBasicSelectionViewController *selectionVC = segue.destinationViewController;

    if ([segue.identifier isEqualToString:kVisitTypeSegue]) {

        selectionVC.key = kAppointmentType;
        selectionVC.reuseIdentifier = kAppointmentTypeCell;
        selectionVC.titleText = kTypeOfVisitPrompt;

        selectionVC.configureCellBlock = ^(AppointmentTypeCell *cell, AppointmentType *appointmentType) {
            cell.selectedColor = self.card.tintColor;

            [cell configureForAppointmentType:appointmentType];

            shouldSelect = NO;

            if ([appointmentType.objectID isEqualToString:[self appointment].appointmentType.objectID]) {
                shouldSelect = YES;
            }

            return shouldSelect;
        };

        selectionVC.requestOperation = [[LEOAPIAppointmentTypesOperation alloc] init];
        selectionVC.delegate = self;

    } else if ([segue.identifier isEqualToString:kPatientSegue]) {

        selectionVC.key = kSelectionVCPatientKey;
        selectionVC.reuseIdentifier = kPatientCell;
        selectionVC.titleText = kPatientPrompt;

        selectionVC.configureCellBlock = ^(PatientCell *cell, Patient *patient) {

            cell.selectedColor = self.card.tintColor;

            shouldSelect = NO;

            [cell configureForPatient:patient];

            if ([patient.objectID isEqualToString:[self appointment].patient.objectID]) {
                shouldSelect = YES;
            }

            return shouldSelect;
        };

        selectionVC.requestOperation = [[LEOAPIFamilyOperation alloc] init];
        selectionVC.delegate = self;

    } else if ([segue.identifier isEqualToString:kStaffSegue]) {

        selectionVC.key = kSelectionVCProviderKey;
        selectionVC.reuseIdentifier = kProviderCell;
        selectionVC.titleText = kProviderPrompt;
        selectionVC.feature = FeatureAppointmentScheduling;
        selectionVC.configureCellBlock = ^(ProviderCell *cell, Provider *provider) {

            cell.selectedColor = self.card.tintColor;

            shouldSelect = NO;

            if ([provider.objectID isEqualToString:[self appointment].provider.objectID]) {
                shouldSelect = YES;
            }

            [cell configureForProvider:provider];

            return shouldSelect;
        };

        selectionVC.requestOperation = [[LEOAPIPracticeOperation alloc] init];
        selectionVC.delegate = self;
    }

    if ([segue.identifier isEqualToString:kScheduleSegue]) {

        LEOCalendarViewController *calendarVC = segue.destinationViewController;

        calendarVC.delegate = self;
        calendarVC.appointment = self.appointmentView.appointment;
        calendarVC.requestOperation = [[LEOAPISlotsOperation alloc] initWithAppointment:self.appointmentView.appointment];

        return;
    }
}

#pragma mark - Actions

-(void)didUpdateItem:(id)item forKey:(NSString *)key {

    if ([key isEqualToString:kAppointmentType]) {
        self.appointmentView.appointmentType = item;
    }

    else if ([key isEqualToString:kSelectionVCPatientKey]) {
        self.appointmentView.patient = item;
    }

    else if ([key isEqualToString:kSelectionVCProviderKey]) {
        self.appointmentView.provider = item;
    }

    else if ([key isEqualToString:kSelectionVCDateKey]) {
        self.appointmentView.date = item;
    }

    self.submissionButton.enabled = self.appointment.isValidForBooking;
}

-(void)submitCardUpdates {

    LEOAppointmentService *appointmentService = [LEOAppointmentService new];

    self.appointment.status.statusCode = AppointmentStatusCodeFuture;

    [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];

    __weak LEOAppointmentViewController *weakself = self;

    if (!self.appointment.objectID) {

        [appointmentService createAppointmentWithAppointment:self.appointment withCompletion:^(LEOCardAppointment * appointmentCard, NSError * error) {

            if (!error) {

                weakself.card = appointmentCard;
                [self.appointment book];
            }

            [MBProgressHUD hideHUDForView:weakself.view.window animated:YES];
        }];
    } else {

        [appointmentService rescheduleAppointmentWithAppointment:self.appointment withCompletion:^(LEOCardAppointment * appointmentCard, NSError *error) {


            if (!error) {

                weakself.card = appointmentCard;
                [self.appointment book];
            }
            
            [MBProgressHUD hideHUDForView:weakself.view.window animated:YES];
        }];
    }
}

-(void)didUpdateObjectStateForCard:(id<LEOCardProtocol>)card {
    [self dismiss];
}

-(void)dismiss {

    [self.delegate takeResponsibilityForCard:self.card];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
    }];
}


@end

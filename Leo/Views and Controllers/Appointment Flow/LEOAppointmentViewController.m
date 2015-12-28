
//
//  LEOAppointmentViewController.m
//  Leo
//
//  Created by Zachary Drossman on 11/24/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOAppointmentViewController.h"
#import "LEOAppointmentView.h"
#import "LEOCardAppointment.h"

#import "LEOStyleHelper.h"
#import "UIColor+LeoColors.h"

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

@interface LEOAppointmentViewController ()

@property (weak, nonatomic) LEOAppointmentView *appointmentView;
@property (strong, nonatomic) LEOGradientView *gradientView;
@property (strong, nonatomic) Appointment *appointment;

@end

@implementation LEOAppointmentViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.feature = FeatureAppointmentScheduling;

    [self setupNavigationBar];

    self.stickyHeaderView.meetsSubmissionRequirements = self.appointment.isValidForBooking;
    self.stickyHeaderView.snapToHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    [self setupNavigationBar];

    [self.view updateConstraints];

}

- (void)setupNavigationBar {

    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:self.feature withTitleText:self.card.title dismissal:YES backButton:NO];
}


-(void)setCard:(LEOCardAppointment *)card {

    _card = card;
    _card.activityDelegate = self;

    self.stickyHeaderView.datasource = self;
    self.stickyHeaderView.delegate = self;
}


-(void)didUpdateItem:(id)item forKey:(NSString *)key {

    if ([key isEqualToString:@"appointmentType"]) {
        self.appointmentView.appointmentType = item;
    }

    else if ([key isEqualToString:@"patient"]) {
        self.appointmentView.patient = item;
    }

    else if ([key isEqualToString:@"provider"]) {
        self.appointmentView.provider = item;
    }

    else if ([key isEqualToString:@"date"]) {
        self.appointmentView.date = item;
    }

    self.stickyHeaderView.meetsSubmissionRequirements = self.appointment.isValidForBooking;
}

- (void)viewDidLayoutSubviews {

    [super viewDidLayoutSubviews];

    CGFloat percentageForTopOfVisibleView = 1 - (CGRectGetHeight(self.gradientView.bounds) / CGRectGetHeight(self.gradientView.gradientLayerBounds));
    self.gradientView.initialStartPoint = CGPointMake(0.4, percentageForTopOfVisibleView);

    self.gradientView.initialEndPoint = CGPointMake(0.7, 1);

    CGFloat percentageForTopOfNavBar = 1 - (CGRectGetHeight(self.navigationController.navigationBar.bounds) / CGRectGetHeight(self.gradientView.gradientLayerBounds));
    self.gradientView.finalStartPoint = CGPointMake(0.2, percentageForTopOfNavBar);

    self.gradientView.finalEndPoint = CGPointMake(0.9, 1);
}

- (UIView *)injectTitleView {

    LEOGradientView *strongView = self.gradientView;
    return strongView;
}

- (LEOGradientView *)gradientView {

    if (!_gradientView) {

        LEOGradientView *strongView = [LEOGradientView new];
        _gradientView = strongView;

        _gradientView.colors = @[(id)[UIColor leo_green].CGColor, (id)[UIColor leo_white].CGColor];
        _gradientView.titleText = self.card.title;

    }
    return _gradientView;
}

- (void)updateTitleViewForScrollTransitionPercentage:(CGFloat)transitionPercentage {
    self.gradientView.currentTransitionPercentage = transitionPercentage;
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

- (Appointment *)appointment {

    return self.appointmentView.appointment;
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

-(void)leo_performSegueWithIdentifier:(NSString *)segueIdentifier {
    [self performSegueWithIdentifier:segueIdentifier sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    __block BOOL shouldSelect = NO;

    LEOBasicSelectionViewController *selectionVC = segue.destinationViewController;

    if ([segue.identifier isEqualToString:@"VisitTypeSegue"]) {

        selectionVC.key = @"appointmentType";
        selectionVC.reuseIdentifier = @"AppointmentTypeCell";
        selectionVC.titleText = @"What type of visit is this?";

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
    } else if ([segue.identifier isEqualToString:@"PatientSegue"]) {

        selectionVC.key = @"patient";
        selectionVC.reuseIdentifier = @"PatientCell";
        selectionVC.titleText = @"Who is the visit for?";

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
    } else if ([segue.identifier isEqualToString:@"StaffSegue"]) {

        selectionVC.key = @"provider";
        selectionVC.reuseIdentifier = @"ProviderCell";
        selectionVC.titleText = @"Who would you like to see?";
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

    if ([segue.identifier isEqualToString:@"ScheduleSegue"]) {

        LEOCalendarViewController *calendarVC = segue.destinationViewController;

        calendarVC.delegate = self;
        calendarVC.appointment = self.appointmentView.appointment;
        calendarVC.requestOperation = [[LEOAPISlotsOperation alloc] initWithAppointment:self.appointmentView.appointment];

        return;
    }
}


#pragma mark - Actions
- (void)didUpdateObjectStateForCard:(id<LEOCardProtocol>)card {
    [self dismiss];
}

- (void)dismiss {

    [self.delegate takeResponsibilityForCard:self.card];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)dealloc {
    //TODO: Remove after debugging complete.
}

@end

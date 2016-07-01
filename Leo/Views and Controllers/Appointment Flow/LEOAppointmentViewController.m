
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
#import "UIImage+Extensions.h"

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
#import "Appointment+Analytics.h"
#import "Patient.h"
#import "Slot.h"
#import "Practice.h"
#import "AppointmentStatus.h"

#import <MBProgressHUD.h>

#import "LEOGradientView.h"
#import "LEOAppointmentService.h"
#import "UIButton+Extensions.h"
#import "LEOCachedDataStore.h"
#import "LEOAnalyticSession.h"
#import "LEOAnalyticScreen.h"
#import "LEOSession.h"
#import "Guardian.h"
#import "LEOAnalyticEvent.h"
#import "LEOAnalyticIntent.h"

@interface LEOAppointmentViewController ()

@property (weak, nonatomic) LEOAppointmentView *appointmentView;
@property (strong, nonatomic) LEOGradientView *gradientView;
@property (strong, nonatomic) UIButton *submissionButton;
@property (strong, nonatomic) Appointment *appointment;

@property (nonatomic) BOOL didLayoutSubviewsOnce;
@property (strong, nonatomic) LEOAnalyticSession *analyticSession;

@end

@implementation LEOAppointmentViewController

static CGFloat const kRightTitleInsetAppointments = 100;
static CGFloat const kBottomTitleInsetAppointments = 20;

static NSString *const kCopySubmitAppointment = @"CONFIRM VISIT";

// Appointment Segue constants
static NSString *const kCopyTitleScheduleVisit = @"Let's schedule a visit";
static NSString *const kSegueVisitType = @"VisitTypeSegue";
static NSString *const kKeySelectionVCAppointmentType = @"appointmentType";
static NSString *const kCellAppointmentType = @"AppointmentTypeCell";
static NSString *const kPromptTypeOfVisit = @"Choose a visit type";

// Patient segue constants
static NSString *const kSeguePatient = @"PatientSegue";
static NSString *const kKeySelectionVCPatient = @"patient";
static NSString *const kCellPatient = @"PatientCell";
static NSString *const kPromptPatient = @"Choose a child";

// Staff/Schedule segue constants
static NSString *const kSegueStaff = @"StaffSegue";
static NSString *const kKeySelectionVCProvider = @"provider";
static NSString *const kCellProvider = @"ProviderCell";
static NSString *const kPromptProvider = @"Who would you like to see?";
static NSString *const kSegueSchedule = @"ScheduleSegue";
static NSString *const kKeySelectionVCDate = @"date";

#pragma mark - View Lifecycle

-(void)viewDidLoad {

    [super viewDidLoad];

    self.analyticSession = [LEOAnalyticSession startSessionWithSessionEventName:kAnalyticSessionScheduling];
    self.feature = FeatureAppointmentScheduling;

    [self setupNavigationBar];

    self.submissionButton.enabled = self.appointment.isValidForBooking;
    self.stickyHeaderView.snapToHeight = @(CGRectGetHeight(self.navigationController.navigationBar.bounds));
    self.stickyHeaderView.datasource = self;
    self.stickyHeaderView.delegate = self;

    [LEOStyleHelper roundCornersForView:self.navigationController.view withCornerRadius:kCornerRadius];
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    __weak LEOAppointmentViewController* weakSelf = self;
    [self addAnimationToNavBar:^{
        [weakSelf.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        CGFloat percentage = [weakSelf transitionPercentageForScrollOffset:weakSelf.stickyHeaderView.scrollView.contentOffset];
        weakSelf.navigationItem.titleView.hidden = percentage == 0;
    }];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [LEOAnalyticScreen tagScreen:kAnalyticScreenAppointmentScheduling];

    [LEOApiReachability startMonitoringForController:self withOfflineBlock:nil withOnlineBlock:^{
        self.submissionButton.enabled = self.appointment.isValidForBooking;
    }];
}

-(void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];

    [self.view endEditing:YES];

    // only apply the gradient nav bar when pushing
    BOOL pushingAViewController = self.navigationController.viewControllers.count > 1;
    if (pushingAViewController) {

        // Match the gradient in consecutive nav bars
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.navigationController.navigationBar.bounds;
        gradient.colors = self.gradientView.colors;
        gradient.startPoint = CGPointMake(0,0);
        gradient.endPoint = CGPointMake(1, 1);

        __weak LEOAppointmentViewController *weakSelf = self;
        void(^animations)() = ^(){
            [weakSelf.navigationController.navigationBar setBackgroundImage:[UIImage leo_imageFromLayer:gradient] forBarMetrics:UIBarMetricsDefault];
        };

        if (self.stickyHeaderView.isCollapsed) {
            animations();
        } else {
            [self addAnimationToNavBar:animations];
        }
    }
}

-(void)setupNavigationBar {

    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:self.feature withTitleText:kCopyTitleScheduleVisit dismissal:YES backButton:NO];
}

#pragma mark - Layout

- (void)viewDidLayoutSubviews {

    [super viewDidLayoutSubviews];

    if (!self.didLayoutSubviewsOnce) {

        // To get an accurate angle for the gradient, place the start and end points on the edge a circle that is centered in the view
        CGFloat y2 = 1;
        CGPoint start;
        CGPoint end;

        [self.stickyHeaderView layoutIfNeeded];

        CGRect rect = self.gradientView.bounds;
        CGFloat r = CGRectGetHeight(rect) / CGRectGetHeight(self.gradientView.gradientLayerBounds);

        CGFloat y1 = [LEOGradientHelper translateRelativePosition:0 fromSize:CGRectGetHeight(rect) toSize:CGRectGetHeight(self.gradientView.gradientLayerBounds)];
        CGPoint center = CGPointMake(0.5, y1 + (y2 - y1)/2);
        CGFloat theta = atanf(CGRectGetWidth(rect)/(CGRectGetHeight(rect)/2));
        [LEOGradientHelper gradientStartPoint:&start endPoint:&end withCenter:center withRadius:r withRotationInRadians:theta];

        self.gradientView.initialStartPoint = start;
        self.gradientView.initialEndPoint = end;

        rect = self.navigationController.navigationBar.bounds;
        r = CGRectGetHeight(rect) / CGRectGetHeight(self.gradientView.gradientLayerBounds);
        y1 = [LEOGradientHelper translateRelativePosition:0 fromSize:CGRectGetHeight(rect) toSize:CGRectGetHeight(self.gradientView.gradientLayerBounds)];
        center = CGPointMake(0.5, y1 + (y2 - y1)/2);
        theta = atanf(CGRectGetWidth(rect)/(CGRectGetHeight(rect)/2));
        [LEOGradientHelper gradientStartPoint:&start endPoint:&end withCenter:center withRadius:r withRotationInRadians:theta];

        self.gradientView.finalStartPoint = start;
        self.gradientView.finalEndPoint = end;
        
        self.didLayoutSubviewsOnce = YES;
    }
}

#pragma mark - StickyHeaderView Delegate

- (UIView *)injectTitleView {
    return self.gradientView;
}

- (LEOGradientView *)gradientView {

    if (!_gradientView) {

        LEOGradientView *strongView = [[LEOGradientView alloc] initWithTitleText:kCopyTitleScheduleVisit];
        _gradientView = strongView;
        UIColor *startColor = [LEOStyleHelper gradientStartColorForFeature:self.feature];
        UIColor *endColor = [LEOStyleHelper gradientEndColorForFeature:self.feature];
        _gradientView.colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
        [LEOStyleHelper styleExpandedTitleLabel:_gradientView.titleLabel feature:self.feature];
        _gradientView.intrinsicHeight = @(kStickyHeaderHeight);
        _gradientView.rightTitleInset = @(kRightTitleInsetAppointments);
        _gradientView.bottomTitleInset = @(kBottomTitleInsetAppointments);
    }

    return _gradientView;
}

-(UIView *)injectFooterView {
    return self.submissionButton;
}

-(UIButton *)submissionButton {

    if (!_submissionButton) {

        UIButton *strongButton = [UIButton leo_newButtonWithDisabledStyling];

        _submissionButton = strongButton;

        // TODO: Add a public API to LEOStickyHeaderView to set footer height 
        _submissionButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_submissionButton addConstraint:[NSLayoutConstraint constraintWithItem:_submissionButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44]];

        [LEOStyleHelper styleSubmissionButton:_submissionButton forFeature:self.feature];
        [_submissionButton addTarget:self action:@selector(submitCardUpdates) forControlEvents:UIControlEventTouchUpInside];
        [_submissionButton setTitle:kCopySubmitAppointment forState:UIControlStateNormal];
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

        _appointmentView.appointment = self.card.associatedCardObject;
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

    [LEOBreadcrumb crumbWithFunction:__PRETTY_FUNCTION__];


    if ([segue.identifier isEqualToString:kSegueSchedule]) {

        LEOCalendarViewController *calendarVC = segue.destinationViewController;

        calendarVC.delegate = self;
        calendarVC.appointment = self.appointmentView.appointment;

        return;
    }

    
    __block BOOL shouldSelect = NO;

    LEOBasicSelectionViewController *selectionVC = segue.destinationViewController;
    selectionVC.feature = FeatureAppointmentScheduling;

    if ([segue.identifier isEqualToString:kSegueVisitType]) {

        selectionVC.key = kKeySelectionVCAppointmentType;
        selectionVC.reuseIdentifier = kCellAppointmentType;
        selectionVC.titleText = kPromptTypeOfVisit;

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

    } else if ([segue.identifier isEqualToString:kSeguePatient]) {

        selectionVC.key = kKeySelectionVCPatient;
        selectionVC.reuseIdentifier = kCellPatient;
        selectionVC.titleText = kPromptPatient;

        selectionVC.configureCellBlock = ^(PatientCell *cell, Patient *patient) {

            cell.selectedColor = self.card.tintColor;

            shouldSelect = NO;

            [cell configureForPatient:patient];

            if ([patient.objectID isEqualToString:[self appointment].patient.objectID]) {
                shouldSelect = YES;
            }

            return shouldSelect;
        };

        __weak typeof(selectionVC) weakVC = selectionVC;
        selectionVC.notificationBlock = ^(NSIndexPath *indexPath, Patient *patient, UITableView *tableView) {

            __strong typeof(selectionVC) strongVC = weakVC;

            // TODO: this observer gets added every time the tableView reloads data. Right now not harmful, but lets refactor so it only is added once
            id observer = [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationDownloadedImageUpdated object:patient.avatar queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull notification) {
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
            [strongVC.notificationObservers addObject:observer];
        };
        
        selectionVC.requestOperation = [[LEOAPIFamilyOperation alloc] init];
        selectionVC.delegate = self;

    } else if ([segue.identifier isEqualToString:kSegueStaff]) {

        selectionVC.key = kKeySelectionVCProvider;
        selectionVC.reuseIdentifier = kCellProvider;
        selectionVC.titleText = kPromptProvider;
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
}

#pragma mark - Actions

-(void)didUpdateItem:(id)item forKey:(NSString *)key {

    if ([key isEqualToString:kKeySelectionVCAppointmentType]) {
        self.appointmentView.appointmentType = item;
    }

    else if ([key isEqualToString:kKeySelectionVCPatient]) {
        self.appointmentView.patient = item;
    }

    else if ([key isEqualToString:kKeySelectionVCProvider]) {
        self.appointmentView.provider = item;
    }

    else if ([key isEqualToString:kKeySelectionVCDate]) {
        self.appointmentView.date = item;
    }

    else if ([key isEqualToString:kKeySelectionVCSlot]) {

        Slot *slot = (Slot *)item;

        //FIXME: This is potentially a major bug. Must be reviewed to determine if it is for the next release. (It could be nil and the rest of this will fail.)
        NSArray *providers = [LEOCachedDataStore sharedInstance].practice.providers;
        Provider *provider;
        for (Provider *p in providers) {

            if ([p.objectID isEqualToString:slot.providerID]) {

                provider = p;
                break;
            }
        }
        self.appointmentView.provider = provider;
        self.appointmentView.date = slot.startDateTime;
    }

    self.submissionButton.enabled = self.appointment.isValidForBooking;
}

-(void)setCard:(LEOCardAppointment *)card {

    _card = card;
    _card.activityDelegate = self;
}

-(void)submitCardUpdates {

    LEOAppointmentService *appointmentService = [LEOAppointmentService new];

    self.appointment.status.statusCode = AppointmentStatusCodeFuture;

    [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    self.submissionButton.enabled = NO;

    __weak LEOAppointmentViewController *weakself = self;
    
    if (!self.appointment.objectID) {

        [appointmentService createAppointmentWithAppointment:self.appointment withCompletion:^(LEOCardAppointment * appointmentCard, NSError * error) {

            [MBProgressHUD hideHUDForView:weakself.view.window animated:YES];
            self.submissionButton.enabled = YES;

            if (!error) {
                NSDictionary *dictionary = [self.appointment getAttributes];
                [LEOAnalyticEvent tagEvent:kAnalyticEventBookVisit
                           withAppointment:self.appointment];
                weakself.card = appointmentCard;
                [self.appointment book];
            }
        }];
    } else {

        [appointmentService rescheduleAppointmentWithAppointment:self.appointment withCompletion:^(LEOCardAppointment * appointmentCard, NSError *error) {

            [MBProgressHUD hideHUDForView:weakself.view.window animated:YES];
            self.submissionButton.enabled = YES;

            if (!error) {

                Guardian *guardian = [LEOSession user];
                NSString *membershipTypeString = [Guardian membershipStringFromType:guardian.membershipType];
                
                [LEOAnalyticIntent tagEvent:kAnalyticEventRescheduleVisit
                             withAttributes:@{@"Membership Type" : membershipTypeString}];
                
                weakself.card = appointmentCard;
                [self.appointment book];
            }
        }];
    }
}

-(void)didUpdateObjectStateForCard:(id<LEOCardProtocol>)card {
    [self dismiss];
}

-(void)dismiss {

    [self.analyticSession completeSession];
    [self.delegate takeResponsibilityForCard:self.card];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end

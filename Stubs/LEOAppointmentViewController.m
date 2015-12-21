
//
//  LEOAppointmentViewController.m
//  Leo
//
//  Created by Zachary Drossman on 11/24/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOAppointmentViewController.h"
#import "LEOAppointmentView.h"
#import "LEOCard.h"

#import "LEOStyleHelper.h"

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

@interface LEOAppointmentViewController ()

@property (weak, nonatomic) LEOStickyHeaderView *stickyHeaderView;
@property (strong, nonatomic) LEOAppointmentView *appointmentView;

@end

@implementation LEOAppointmentViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.feature = FeatureAppointmentScheduling;
    
    [self setupNavigationBar];


    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    [self.view updateConstraints];

    self.stickyHeaderView.delegate = self;

}

- (void)setupNavigationBar {
    
    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:self.feature withTitleText:self.card.title dismissal:YES];
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
}

- (UIView *)injectBodyView {
    
    self.appointmentView.delegate = self;
    return self.appointmentView;
}

-(LEOAppointmentView *)appointmentView {

    if (!_appointmentView) {

        _appointmentView = [[LEOAppointmentView alloc] initWithAppointment:[self appointment]];
    }

    return _appointmentView;
}

- (Appointment *)appointment {
    return (Appointment *)self.card.associatedCardObject;
}

-(LEOStickyHeaderView *)stickyHeaderView {
    
    if (!_stickyHeaderView) {
        
        LEOStickyHeaderView *strongView = [LEOStickyHeaderView new];
        
        _stickyHeaderView = strongView;
        
        [self.view addSubview:_stickyHeaderView];

        [self layoutStickyHeaderView];
    }
    
    return _stickyHeaderView;
}

- (void)layoutStickyHeaderView {

    self.stickyHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *bindings = NSDictionaryOfVariableBindings(_stickyHeaderView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_stickyHeaderView]|" options:0 metrics:nil views:bindings]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_stickyHeaderView]|" options:0 metrics:nil views:bindings]];
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


@end

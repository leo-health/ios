//
//  LEOFeedTVC.m
//  Leo
//
//  Created by Zachary Drossman on 5/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOFeedTVC.h"

#import <OHHTTPStubs/OHHTTPStubs.h>
#import <NSDate+DateTools.h>

#import "LEOCardView.h"
#import "ArrayDataSource.h"
#import "LEOCardCell.h"
#import "LEOCard.h"

#import "LEOConstants.h"
#import "LEOApiClient.h"
#import "LEODataManager.h"

#import "User.h"
#import "Role.h"
#import "Appointment.h"
#import "Conversation.h"
#import "Message.h"

#import "UIColor+LeoColors.h"
#import "UIImage+Extensions.h"
#import "LEOAppointmentSchedulingCardVC.h"
#import "LEOTransitioningDelegate.h"

#import "LEOTwoButtonSecondaryOnlyCell+ConfigureForCell.h"
#import "LEOOneButtonSecondaryOnlyCell+ConfigureForCell.h"
#import "LEOTwoButtonPrimaryOnlyCell+ConfigureForCell.h"
#import "LEOOneButtonPrimaryOnlyCell+ConfigureForCell.h"
#import "LEOTwoButtonPrimaryAndSecondaryCell+ConfigureForCell.h"
#import "LEOOneButtonPrimaryAndSecondaryCell+ConfigureForCell.h"

#import <VBFPopFlatButton/VBFPopFlatButton.h>
#import "UIImageEffects.h"

#import "AppDelegate.h"

@interface LEOFeedTVC ()

@property (strong, nonatomic) LEODataManager *coreDataManager;
@property (nonatomic, strong) ArrayDataSource *cardsArrayDataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) LEOTransitioningDelegate *transitionDelegate;

@property (strong, nonatomic) UITableViewCell *selectedCardCell;

@end

@implementation LEOFeedTVC

static NSString *const adminTestKey = @""; //FIXME: REMOVE BEFORE SENDING OFF TO PRODUCTION!

static NSString *const CellIdentifierLEOCardTwoButtonSecondaryOnly = @"LEOTwoButtonSecondaryOnlyCell";
static NSString *const CellIdentifierLEOCardTwoButtonPrimaryAndSecondary = @"LEOTwoButtonPrimaryAndSecondaryCell";
static NSString *const CellIdentifierLEOCardTwoButtonPrimaryOnly = @"LEOTwoButtonPrimaryOnlyCell";
static NSString *const CellIdentifierLEOCardOneButtonSecondaryOnly = @"LEOOneButtonSecondaryOnlyCell";
static NSString *const CellIdentifierLEOCardOneButtonPrimaryAndSecondary = @"LEOOneButtonPrimaryAndSecondaryCell";
static NSString *const CellIdentifierLEOCardOneButtonPrimaryOnly = @"LEOOneButtonPrimaryOnlyCell";



#pragma mark - View Controller Lifecycle and VCL Helper Methods
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //    [self testAPI]; //TODO: Remove this line once moved what is in this method to a test.
    [self.coreDataManager fetchCardsWithCompletion:^{
        [self tableViewSetup];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.tableView reloadData];
}



- (void)tableViewSetup {
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.estimatedRowHeight = 180;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = [UIColor leoBasicGray];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[LEOTwoButtonPrimaryOnlyCell nib] forCellReuseIdentifier:CellIdentifierLEOCardTwoButtonPrimaryOnly];
    [self.tableView registerNib:[LEOOneButtonPrimaryOnlyCell nib] forCellReuseIdentifier:CellIdentifierLEOCardOneButtonPrimaryOnly];
    [self.tableView registerNib:[LEOTwoButtonSecondaryOnlyCell nib] forCellReuseIdentifier:CellIdentifierLEOCardTwoButtonSecondaryOnly];
    [self.tableView registerNib:[LEOOneButtonSecondaryOnlyCell nib] forCellReuseIdentifier:CellIdentifierLEOCardOneButtonSecondaryOnly];
    [self.tableView registerNib:[LEOTwoButtonPrimaryAndSecondaryCell nib] forCellReuseIdentifier:CellIdentifierLEOCardTwoButtonPrimaryAndSecondary];
    [self.tableView registerNib:[LEOOneButtonPrimaryAndSecondaryCell nib] forCellReuseIdentifier:CellIdentifierLEOCardOneButtonPrimaryAndSecondary];
}



#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LEOCardCell *cell = (LEOCardCell *)[tableView cellForRowAtIndexPath:indexPath];
    self.selectedCardCell = cell;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (void)didUpdateObjectStateForCard:(LEOCard *)card {
    
    [UIView animateWithDuration:0.2 animations:^{
        //self.selectedCardCell.layer.transform = CATransform3DMakeRotation(M_PI_2,0.0,1.0,0.0); ; //flip halfway, TODO: Determine what the appropiate thing is to do with the collapsed card view.
    } completion:^(BOOL finished) {
        
        if ([card.associatedCardObject isKindOfClass:[Appointment class]]) {
            
            Appointment *appointment = card.associatedCardObject;
            
            if (appointment.appointmentState == AppointmentStateBooking) {
                UIStoryboard *schedulingStoryboard = [UIStoryboard storyboardWithName:@"Scheduling" bundle:nil];
                LEOAppointmentSchedulingCardVC *singleAppointmentScheduleVC = [schedulingStoryboard instantiateInitialViewController];
                singleAppointmentScheduleVC.card = (LEOCardScheduling *)card;
                //              self.transitionDelegate = [[LEOTransitioningDelegate alloc] init];
                //            singleAppointmentScheduleVC.transitioningDelegate = self.transitionDelegate;
                [self presentViewController:singleAppointmentScheduleVC animated:YES completion:^{
                    singleAppointmentScheduleVC.collapsedCell = self.selectedCardCell;
                }];
            }
            else {
                [self.tableView reloadData]; //TODO: This is not right, but for now it is a placeholder.
            }
        }
    }];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.coreDataManager.cards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LEOCard *card = self.coreDataManager.cards[indexPath.row];
    card.delegate = self;
    
    NSString *cellIdentifier;
    
    switch (card.layout) {
        case CardLayoutTwoButtonSecondaryOnly: {
            cellIdentifier = CellIdentifierLEOCardTwoButtonSecondaryOnly;
            LEOTwoButtonSecondaryOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                                  forIndexPath:indexPath];
            [cell configureForCard:card];
            
            return cell;
        }
           
        case CardLayoutOneButtonSecondaryOnly: {
            cellIdentifier = CellIdentifierLEOCardOneButtonSecondaryOnly;
            LEOOneButtonSecondaryOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                                forIndexPath:indexPath];
            [cell configureForCard:card];
            
            return cell;
        }
            
        case CardLayoutTwoButtonPrimaryOnly: {
            cellIdentifier = CellIdentifierLEOCardTwoButtonPrimaryOnly;
            LEOTwoButtonPrimaryOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                                forIndexPath:indexPath];
            [cell configureForCard:card];
            
            return cell;
        }
            
        case CardLayoutOneButtonPrimaryOnly: {
            cellIdentifier = CellIdentifierLEOCardOneButtonPrimaryOnly;
            LEOOneButtonPrimaryOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                                forIndexPath:indexPath];
            [cell configureForCard:card];
            
            return cell;
        }
         
        case CardLayoutTwoButtonPrimaryAndSecondary: {
            cellIdentifier = CellIdentifierLEOCardTwoButtonPrimaryAndSecondary;
            
            LEOTwoButtonPrimaryAndSecondaryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            [cell configureForCard:card];
            
            
            return cell;
        }

        case CardLayoutOneButtonPrimaryAndSecondary: {
            cellIdentifier = CellIdentifierLEOCardOneButtonPrimaryAndSecondary;
            
            LEOOneButtonPrimaryAndSecondaryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                                forIndexPath:indexPath];
            
            [cell configureForCard:card];

            return cell;
        }
            
        case CardLayoutUndefined: {
            //TODO: Should deal with this as an error of some sort.
            return nil;
        }
    }
}

- (LEODataManager *)coreDataManager {
    
    if (!_coreDataManager) {
        _coreDataManager = [LEODataManager sharedManager];
    }
    
    return _coreDataManager;
}


@end

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
#import "Family.h"
#import "Practice.h"

#import "UIColor+LeoColors.h"
#import "UIImage+Extensions.h"
#import "LEOCardSchedulingBookingVC.h"
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

@property (strong, nonatomic) LEODataManager *dataManager;
@property (nonatomic, strong) ArrayDataSource *cardsArrayDataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) LEOTransitioningDelegate *transitionDelegate;

@property (strong, nonatomic) UITableViewCell *selectedCardCell;
@property (strong, nonatomic) NSArray *cards;
@property (strong, nonatomic) Family *family;
@property (strong, nonatomic) NSArray *providers;
@property (strong, nonatomic) NSArray *visitTypes;

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
    
    // Registering as observer from one object
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(beginSchedulingNewAppointment)
                                                 name:@"requestToBookNewAppointment"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchData) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [self setupStubs];
    
    [self tableViewSetup];
}



- (void)setupStubs {
    
    __weak id<OHHTTPStubsDescriptor> cardsStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSLog(@"Request");
        BOOL test = [request.URL.host isEqualToString:APIHost] && [request.URL.path isEqualToString:[NSString stringWithFormat:@"%@/%@",APIVersion, @"cards"]];
        return test;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        
        NSString *fixture = fixture = OHPathForFile(@"getCardsForUser.json", self.class);
        OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        return response;
        
    }];
    
    __weak id<OHHTTPStubsDescriptor> providersStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSLog(@"Request");
        BOOL test = [request.URL.host isEqualToString:APIHost] && [request.URL.path isEqualToString:[NSString stringWithFormat:@"%@/%@",APIVersion, @"providers"]];
        return test;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        
        NSString *fixture = fixture = OHPathForFile(@"getProviders.json", self.class);
        OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        return response;
        
    }];
    
    __weak id<OHHTTPStubsDescriptor> familyStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSLog(@"Request");
        BOOL test = [request.URL.host isEqualToString:APIHost] && [request.URL.path isEqualToString:[NSString stringWithFormat:@"%@/%@",APIVersion, @"family"]];
        return test;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        
        NSString *fixture = fixture = OHPathForFile(@"getFamilyForUser.json", self.class);
        OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        return response;
    }];

    __weak id<OHHTTPStubsDescriptor> visitTypesStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSLog(@"Request");
        BOOL test = [request.URL.host isEqualToString:APIHost] && [request.URL.path isEqualToString:[NSString stringWithFormat:@"%@/%@",APIVersion, @"visitTypes"]];
        return test;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        
        NSString *fixture = fixture = OHPathForFile(@"getVisitTypes.json", self.class);
        OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        return response;
    }];
    
}

- (void)fetchData {
    
    dispatch_queue_t queue = dispatch_queue_create("loadingQueue", NULL);
    
    dispatch_sync(queue, ^{
        [self.dataManager getCardsWithCompletion:^(NSArray *cards) {
            
            self.cards = cards;
            
            dispatch_async(dispatch_get_main_queue() , ^{
                [self.tableView reloadData];
            });
        }];
    });
    
    if (self.family == nil || self.providers == nil || self.visitTypes == nil) {
        
    dispatch_sync(queue, ^{
        [self.dataManager getFamilyWithCompletion:^(Family *family) {
            self.family = family;
        }];
        
        Practice *practice = [[Practice alloc] initWithObjectID:@"0" providers:@[]]; //FIXME: Should not be hardcoded.
        
        [self.dataManager getProvidersForPractice:practice withCompletion:^(NSArray *providers) {
            self.providers = providers;
        }];
        [self.dataManager getVisitTypesWithCompletion:^(NSArray *visitTypes) {
            self.visitTypes = visitTypes;
        }];
    });
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    //FIXME: So, ultimately, this should be a data fetch, but since we aren't actually pushing anything up to the API at this point and the expectation is we would both push and pull at the same time, we're just going to reload data at the moment and we'll deal with this when the time comes to implement the actual API.
    
    if (!self.cards) {
    [self fetchData];
    }
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
        
        if ([card.type isEqualToString:@"appointment"]) { //FIXME: should really be an integer / enum with a displayName if desired.
            
            Appointment *appointment = card.associatedCardObject; //FIXME: Make this a loop to account for multiple appointments.
            
            switch (appointment.appointmentState) {
                case AppointmentStateBooking: {
                    [self loadBookingViewWithCard:card];
                    break;
                }
                    
                case AppointmentStateCancelled: {
                    [self removeCardFromFeed:card];
                    break;
                }

                default: {
                    [self.tableView reloadData]; //TODO: This is not right, but for now it is a placeholder.
                }
            }
        }
    }];
}

- (void)beginSchedulingNewAppointment {

    Appointment *appointment = [[Appointment alloc] initWithObjectID:nil date:nil appointmentType:self.visitTypes[0] patient:self.family.patients[0] provider:self.providers[0] bookedByUser:(User *)[self.dataManager currentUser] note:nil state:@(AppointmentStateBooking)];
    
    LEOCardScheduling *card = [[LEOCardScheduling alloc] initWithObjectID:@"temp" priority:@999 type:@"appointment" associatedCardObject:appointment];

    [self loadBookingViewWithCard:card];
}


- (void)removeCardFromFeed:(LEOCard *)card {
    
    [self.tableView beginUpdates];
    [self removeCard:card];
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:[card.priority integerValue] inSection:0]];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)addCard:(LEOCard *)card {
    
    NSMutableArray *mutableCards = [self.cards mutableCopy];
    
    [mutableCards addObject:card];
    
    self.cards = [mutableCards copy];
}

- (void)removeCard:(LEOCard *)card {
    
    NSMutableArray *mutableCards = [self.cards mutableCopy];
    
    [mutableCards removeObject:card];
    
    self.cards = [mutableCards copy];
}


- (void)loadBookingViewWithCard:(LEOCard *)card {
    
    UIStoryboard *schedulingStoryboard = [UIStoryboard storyboardWithName:@"Scheduling" bundle:nil];
    LEOCardSchedulingBookingVC *singleAppointmentScheduleVC = [schedulingStoryboard instantiateInitialViewController];
    singleAppointmentScheduleVC.card = (LEOCardScheduling *)card;
    singleAppointmentScheduleVC.providers = self.providers;
    singleAppointmentScheduleVC.patients = self.family.patients;
    singleAppointmentScheduleVC.visitTypes = self.visitTypes;
    //              self.transitionDelegate = [[LEOTransitioningDelegate alloc] init];
    //            singleAppointmentScheduleVC.transitioningDelegate = self.transitionDelegate;
    [self presentViewController:singleAppointmentScheduleVC animated:YES completion:^{
        singleAppointmentScheduleVC.collapsedCell = self.selectedCardCell;
    }];
    
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.cards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LEOCard *card = self.cards[indexPath.row];
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

- (LEODataManager *)dataManager {
    
    if (!_dataManager) {
        _dataManager = [LEODataManager sharedManager];
    }
    
    return _dataManager;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

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
#import "LEOCoreDataManager.h"

#import "User+Methods.h"
#import "Role+Methods.h"
#import "Appointment+Methods.h"
#import "Conversation+Methods.h"
#import "Message+Methods.h"

#import "UIColor+LeoColors.h"
#import "UIImage+Extensions.h"
#import "LEOAppointmentSchedulingCardVC.h"
#import "LEOTransitioningDelegate.h"

#import "LEOTwoButtonSecondaryOnlyCell+ConfigureForCell.h"
#import "LEOTwoButtonPrimaryOnlyCell+ConfigureForCell.h"
#import "LEOOneButtonPrimaryOnlyCell+ConfigureForCell.h"

@interface LEOFeedTVC ()

@property (strong, nonatomic) LEOCoreDataManager *coreDataManager;
@property (nonatomic, strong) ArrayDataSource *cardsArrayDataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) LEOTransitioningDelegate *transitionDelegate;

@property (strong, nonatomic) UITableViewCell *selectedCardCell;

@end

@implementation LEOFeedTVC

static NSString *const adminTestKey = @""; //FIXME: REMOVE BEFORE SENDING OFF TO PRODUCTION!

static NSString *const CellIdentifierLEOCardTwoButtonSecondaryOnly = @"LEOTwoButtonSecondaryOnlyCell";
static NSString *const CellIdentifierLEOCardTwoButtonSecondaryAndPrimary = @"LEOTwoButtonSecondaryAndPrimaryCell";
static NSString *const CellIdentifierLEOCardTwoButtonPrimaryOnly = @"LEOTwoButtonPrimaryOnlyCell";
static NSString *const CellIdentifierLEOCardOneButtonSecondaryOnly = @"LEOOneButtonSecondaryOnlyCell";
static NSString *const CellIdentifierLEOCardOneButtonSecondaryAndPrimary = @"LEOOneButtonSecondaryAndPrimaryCell";
static NSString *const CellIdentifierLEOCardOneButtonPrimaryOnly = @"LEOOneButtonPrimaryOnlyCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self testAPI];
    [self.coreDataManager fetchDataWithCompletion:^{
        [self tableViewSetup];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated {
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

    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LEOCardCell *cell = (LEOCardCell *)[tableView cellForRowAtIndexPath:indexPath];
    self.selectedCardCell = cell;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

-(void)didTapButtonOneOnCard:(LEOCard *)card withAssociatedObject:(id)associatedObject {
    
    [UIView animateWithDuration:0.2 animations:^{
        //self.selectedCardCell.layer.transform = CATransform3DMakeRotation(M_PI_2,0.0,1.0,0.0); ; //flip halfway
    } completion:^(BOOL finished) {
        
        if ([associatedObject isKindOfClass:[Appointment class]]) {
            UIStoryboard *schedulingStoryboard = [UIStoryboard storyboardWithName:@"Scheduling" bundle:nil];
            LEOAppointmentSchedulingCardVC *singleAppointmentScheduleVC = [schedulingStoryboard instantiateInitialViewController];
            singleAppointmentScheduleVC.card = (LEOCardScheduling *)card;
            //              self.transitionDelegate = [[LEOTransitioningDelegate alloc] init];
            //            singleAppointmentScheduleVC.transitioningDelegate = self.transitionDelegate;
            [self presentViewController:singleAppointmentScheduleVC animated:YES completion:^{
                singleAppointmentScheduleVC.collapsedCell = self.selectedCardCell;
            }];
        }
    }];
}

-(void)didTapButtonTwoOnCard:(LEOCard *)card withAssociatedObject:(id)associatedObject {

}

-(void)didUpdateObjectStateForCard:(LEOCard *)card {
    //TODO: For now this is fine, but we should be a little more elegant about it and only reload the cell for which the object state changed. We may move to a fetchedResultsController for data to handle that at some point.
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource

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
            
        case CardLayoutTwoButtonPrimaryOnly: {
            cellIdentifier = CellIdentifierLEOCardTwoButtonPrimaryOnly;
            LEOTwoButtonPrimaryOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                                  forIndexPath:indexPath];
            [cell configureForCard:card];

            return cell;
        }
            
        case CardLayoutTwoButtonSecondaryAndPrimary: {
            cellIdentifier = CellIdentifierLEOCardTwoButtonSecondaryAndPrimary;
            
            LEOTwoButtonPrimaryOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                                forIndexPath:indexPath];
            return cell;
        }
            
        case CardLayoutOneButtonPrimaryOnly: {
            cellIdentifier = CellIdentifierLEOCardOneButtonPrimaryOnly;
            
            LEOOneButtonPrimaryOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            [cell configureForCard:card];

            
            return cell;
        }
        
        default:
            break;
    }
    
    return nil;
}




//Not super concerned about this method as it is only temporary. Will ultimately become a part of tests. DYK (did you know): the vast majority of iOS developers don't test (and most of those don't even know how!) These comments are going to have to go once we get more iOS developers...

- (void)testAPI {
    
    Role *parentRole = [Role insertEntityWithName:@"parent" resourceID:@"1" resourceType:@1 managedObjectContext:self.coreDataManager.managedObjectContext];
    NSDate *nowDate = [NSDate date];
    
    User *parentUser = [User insertEntityWithFirstName:@"Marilyn" lastName:@"Drossman" dob:nowDate email:@"md10@leohealth.com" role:parentRole familyID:nil managedObjectContext: self.coreDataManager.managedObjectContext];
    parentUser.title = @"Mrs.";
    parentUser.practiceID = @"1";
    parentUser.middleInitial = @"";
    parentUser.gender = @"female";
    
    __weak id<OHHTTPStubsDescriptor> parentStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSLog(@"Request");
        return [request.URL.host isEqualToString:APIHost] && [request.URL.path isEqualToString:[NSString stringWithFormat:@"%@/%@",APICommonPath, APIEndpointUser]];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        
        NSString *fixture = fixture = OHPathForFile(@"createParentUserResponse.json", self.class);
        OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        return response;
        
    }];
    
    [self.coreDataManager resetPasswordWithEmail:@"md10@leohealth.com" withCompletion:^(NSDictionary * __nonnull rawResults) {
        NSLog(@"RESET PW:%@", rawResults);
    }];
    
    [self.coreDataManager createUserWithUser:parentUser password:@"leohealth" withCompletion:^(NSDictionary * __nonnull rawResults) {
        NSLog(@"%@", rawResults);
        
        [OHHTTPStubs removeStub:parentStub];
        
        [self.coreDataManager loginUserWithEmail:parentUser.email password:@"leohealth" withCompletion:^(NSDictionary * __nonnull rawResults) {
            NSLog(@"%@", rawResults);
            
            self.coreDataManager.currentUser = parentUser;
            self.coreDataManager.userToken = rawResults[@"data"][@"token"]; //temporary until this is being pulled from the keychain
            
            Role *childRole = [Role insertEntityWithName:@"child" resourceID:@"2" resourceType:@2 managedObjectContext:self.coreDataManager.managedObjectContext];
            
            User *childUser = [User insertEntityWithFirstName:@"Zachary" lastName:@"Drossman" dob:[NSDate date] email:@"zd9@leohealth.com" role:childRole familyID:[NSString stringWithFormat:@"%@",@([self.coreDataManager.currentUser.familyID integerValue] + 1)] managedObjectContext:self.coreDataManager.managedObjectContext];
            
            __weak id<OHHTTPStubsDescriptor> childStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                NSLog(@"Request");
                return [request.URL.host isEqualToString:APIHost] && [request.URL.path isEqualToString:[NSString stringWithFormat:@"%@/%@",APICommonPath, APIEndpointUser]];
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                
                NSString *fixture = fixture = OHPathForFile(@"createChildUserResponse.json", self.class);
                OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type":@"application/json"}];
                return response;
                
            }];
            
            if (self.coreDataManager.currentUser) {
                [self.coreDataManager createUserWithUser:childUser password:@"leohealth" withCompletion:^(NSDictionary * __nonnull rawResults) {
                    NSLog(@"%@", rawResults);
                    [OHHTTPStubs removeStub:childStub];
                }];
            } else {
                NSLog(@"No current user existed from which to attach this child.");
            }
            
            NSDate *date = [NSDate dateWithYear:2015 month:12 day:13 hour:2 minute:30 second:0];
            
            // NSString *dateOfDay = [NSString stringWithFormat:@"%ld/%ld/%ld",date.month, date.day, date.year];
            // NSString *timeOfDay = [NSString stringWithFormat:@"%ld:%ld", date.hour, date.minute];
            
            Role *doctorRole = [Role insertEntityWithName:@"doctor" resourceID:@"2" resourceType:@1 managedObjectContext:self.coreDataManager.managedObjectContext];
            User *doctorUser = [User insertEntityWithFirstName:@"Om" lastName:@"Lala" dob:[NSDate date] email:@"om10@leohealth.com" role:doctorRole familyID:nil
                                          managedObjectContext:self.coreDataManager.managedObjectContext];
            doctorUser.credentialSuffix = @"MD";
            doctorUser.title = @"Dr.";

            
            Appointment *zachsAppt = [Appointment insertEntityWithDate:date duration:@30 appointmentType:@1 patient:childUser provider:doctorUser familyID:@"63" bookedByUser:parentUser state:@(AppointmentStateRecommending) managedObjectContext:self.coreDataManager.managedObjectContext];
    
            
            [self.coreDataManager createAppointmentWithAppointment:zachsAppt withCompletion:^(NSDictionary * __nonnull rawResults) {
                NSLog(@"CREATE APPT: %@", rawResults);
                
                [self.coreDataManager getAppointmentsForFamilyOfCurrentUserWithCompletion:^(NSDictionary * __nonnull rawResults) {
                    NSLog(@"GET APPTS: %@", rawResults);
                }];
            }];
            
            [self.coreDataManager getConversationsForCurrentUserWithCompletion:^(NSDictionary * __nonnull rawResults) {
                NSLog(@"GET CONVERSATIONS: %@", rawResults);
                
                Conversation *zachConversation = [Conversation insertEntityWithFamilyID:@([self.coreDataManager.currentUser.familyID integerValue] + 1) conversationID:rawResults[@"data"][@"conversation"][0][@"id"] managedObjectContext:self.coreDataManager.managedObjectContext];
                
                Message *firstMessage = [Message insertEntityWithBody:@"Hello World!" senderID:self.coreDataManager.currentUser.id managedObjectContext:self.coreDataManager.managedObjectContext];
                
                [self.coreDataManager createMessage:firstMessage forConversation:zachConversation withCompletion:^ void(NSDictionary * __nonnull rawResults) {
                    
                    NSLog(@"CREATE MESSAGE: %@", rawResults);
                    
                    [self.coreDataManager getMessagesForConversation:zachConversation withCompletion:^ void(NSDictionary * __nonnull rawResults) {
                        NSLog(@"GET MESSAGES: %@", rawResults);
                    }];
                }];
            }];
        }];
    }];
}


-(LEOCoreDataManager *)coreDataManager {
    if (!_coreDataManager) {
        _coreDataManager = [LEOCoreDataManager sharedManager];
    }
    
    return _coreDataManager;
}


@end

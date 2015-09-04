//
//  LEOFeedTVC.m
//  Leo
//
//  Created by Zachary Drossman on 5/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOFeedTVC.h"

#import <NSDate+DateTools.h>

#import "LEOCardView.h"
#import "ArrayDataSource.h"
#import "LEOCardCell.h"
#import "LEOCard.h"

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
#import "LEOExpandedCardAppointmentViewController.h"
#import "LEOCardAppointment.h"
#import "LEOTransitioningDelegate.h"
#import "LEOCardConversationChattingVC.h"

#import "LEOTwoButtonSecondaryOnlyCell+ConfigureForCell.h"
#import "LEOOneButtonSecondaryOnlyCell+ConfigureForCell.h"
#import "LEOTwoButtonPrimaryOnlyCell+ConfigureForCell.h"
#import "LEOOneButtonPrimaryOnlyCell+ConfigureForCell.h"
#import "LEOTwoButtonPrimaryAndSecondaryCell+ConfigureForCell.h"
#import "LEOOneButtonPrimaryAndSecondaryCell+ConfigureForCell.h"

#import <VBFPopFlatButton/VBFPopFlatButton.h>
#import "UIImageEffects.h"

#import "AppDelegate.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import "Configuration.h"

@interface LEOFeedTVC ()

@property (strong, nonatomic) LEODataManager *dataManager;
@property (nonatomic, strong) ArrayDataSource *cardsArrayDataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) LEOTransitioningDelegate *transitionDelegate;

@property (strong, nonatomic) UITableViewCell *selectedCardCell;
@property (retain, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) Family *family;
@property (copy, nonatomic) NSArray *allStaff;
@property (copy, nonatomic) NSArray *appointmentTypes;

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
    
    [self tableViewSetup];
}

- (void)fetchData {
    
    dispatch_queue_t queue = dispatch_queue_create("loadingQueue", NULL);
    
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];

    dispatch_sync(queue, ^{
                
        [self.dataManager getCardsWithCompletion:^(NSArray *cards, NSError *error) {
            
            if (!error) {
                self.cards = [cards mutableCopy];
            }
            dispatch_async(dispatch_get_main_queue() , ^{
                
                [MBProgressHUD hideHUDForView:self.tableView animated:YES];
                [self.tableView reloadData];
            });
        }];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    
    //FIXME: So, ultimately, this should be a data fetch, but since we aren't actually pushing anything up to the API at this point and the expectation is we would both push and pull at the same time, we're just going to reload data at the moment and we'll deal with this when the time comes to implement the actual API.
    
        [self fetchData];
}

- (void)tableViewSetup {
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = [UIColor leoGrayForMessageBubbles];
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
        
        if (card.type == CardTypeAppointment) { //FIXME: should really be an integer / enum with a displayName if desired.
            
            Appointment *appointment = card.associatedCardObject; //FIXME: Make this a loop to account for multiple appointments.
            
            switch (appointment.statusCode) {
                case AppointmentStatusCodeBooking: {
                    [self loadBookingViewWithCard:card];
                    break;
                }
                    
                case AppointmentStatusCodeCancelled: {
                    [self removeCardFromFeed:card];
                    break;
                }
                    
                case AppointmentStatusCodeCancelling: {
                    [self.tableView reloadData];
                    break;
                }
                    
                case AppointmentStatusCodeConfirmingCancelling: {
                    [self removeCard:card fromDatabaseWithCompletion:^(NSDictionary *response, NSError *error) {
                        if (!error) {
                            
                            [self.tableView reloadData];
                        } else {
                            [card returnToPriorState];
                        }
                    }];
                    break;
                }
                    
                case AppointmentStatusCodeReminding: {
                    
                    [self.tableView reloadData];
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                    }];
                    
                    break;
                }
                    
                default: {
                    [self.tableView reloadData]; //TODO: This is not right, but for now it is a placeholder.
                }
            }
        }
        
        if (card.type == CardTypeConversation) {
            
            Conversation *conversation = card.associatedCardObject; //FIXME: Make this a loop to account for multiple appointments.

            switch (conversation.statusCode) {
                    
                case ConversationStatusCodeClosed: {
                    [self.tableView reloadData];
                    break;
                }
                case ConversationStatusCodeOpen: {
                    [self loadChattingViewWithCard:card];
                    break;
                }   
                default: {
                    break;
                }
                    
                //FIXME: Need to handle "Call us" somehow
            }
        }
    }];
}

- (void)beginSchedulingNewAppointment {

    Appointment *appointment = [[Appointment alloc] initWithObjectID:nil date:nil appointmentType:nil patient:nil provider:nil bookedByUser:(User *)[self.dataManager currentUser] note:nil statusCode:AppointmentStatusCodeBooking];
    
    LEOCardAppointment *card = [[LEOCardAppointment alloc] initWithObjectID:@"temp" priority:@999 type:CardTypeAppointment associatedCardObject:appointment];

    [self loadBookingViewWithCard:card];
}


- (void)removeCard:(LEOCard *)card fromDatabaseWithCompletion:(void (^)(NSDictionary *response, NSError *error))completionBlock {
    
    NSUInteger cardRow = [self.cards indexOfObject:card];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cardRow inSection:0];
    
    LEOCardCell *cell = (LEOCardCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    [MBProgressHUD showHUDAddedTo:cell animated:YES];
    
    [self.dataManager cancelAppointment:card.associatedCardObject withCompletion:^(NSDictionary * response, NSError * error) {
        if (completionBlock) {
            completionBlock(response, error);
            [MBProgressHUD hideHUDForView:cell animated:YES];

        }
    }];
}

- (void)removeCardFromFeed:(LEOCard *)card {
    
    [self.tableView beginUpdates];
    NSUInteger cardRow = [self.cards indexOfObject:card];
    [self removeCard:card];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:cardRow inSection:0]];
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
    
    UIStoryboard *appointmentStoryboard = [UIStoryboard storyboardWithName:@"Appointment" bundle:nil];
    UINavigationController *appointmentNavController = [appointmentStoryboard instantiateInitialViewController];
    LEOExpandedCardAppointmentViewController *appointmentBookingVC = appointmentNavController.viewControllers.firstObject;
    appointmentBookingVC.card = (LEOCardAppointment *)card;
    //              self.transitionDelegate = [[LEOTransitioningDelegate alloc] init];
    //            singleAppointmentScheduleVC.transitioningDelegate = self.transitionDelegate;
    [self presentViewController:appointmentNavController animated:YES completion:^{
    }];
    
}

- (void)loadChattingViewWithCard:(LEOCard *)card {
    
    UIStoryboard *conversationStoryboard = [UIStoryboard storyboardWithName:@"Conversation" bundle:nil];
    LEOCardConversationChattingVC *conversationChattingVC = [conversationStoryboard instantiateInitialViewController];
    conversationChattingVC.card = (LEOCardConversation *)card;
    
    //              self.transitionDelegate = [[LEOTransitioningDelegate alloc] init];
    //            singleAppointmentScheduleVC.transitioningDelegate = self.transitionDelegate;
    [self presentViewController:conversationChattingVC animated:YES completion:^{
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

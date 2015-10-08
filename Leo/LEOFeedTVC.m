//
//  LEOFeedTVC.m
//  Leo
//
//  Created by Zachary Drossman on 5/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOFeedTVC.h"

#import <NSDate+DateTools.h>

#import "ArrayDataSource.h"
#import "LEOCard.h"
#import "LEOCardConversation.h"

#import "LEOCardService.h"
#import "LEOAppointmentService.h"

#import "User.h"
#import "Role.h"
#import "Appointment.h"
#import "Conversation.h"
#import "Message.h"
#import "Family.h"
#import "Practice.h"
#import "SessionUser.h"

#import "UIColor+LeoColors.h"
#import "UIImage+Extensions.h"
#import "LEOExpandedCardAppointmentViewController.h"
#import "LEOMessagesViewController.h"
#import "LEOSettingsViewController.h"

#import "LEOCardAppointment.h"
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

#import <MBProgressHUD/MBProgressHUD.h>
#import "Configuration.h"
#import "LEOPusherHelper.h"

@interface LEOFeedTVC ()

@property (strong, nonatomic) LEOAppointmentService *appointmentService;

@property (nonatomic, strong) ArrayDataSource *cardsArrayDataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) LEOTransitioningDelegate *transitionDelegate;

@property (retain, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) Family *family;
@property (copy, nonatomic) NSArray *allStaff;
@property (copy, nonatomic) NSArray *appointmentTypes;

@end

@implementation LEOFeedTVC

static NSString *const CellIdentifierLEOCardTwoButtonSecondaryOnly = @"LEOTwoButtonSecondaryOnlyCell";
static NSString *const CellIdentifierLEOCardTwoButtonPrimaryAndSecondary = @"LEOTwoButtonPrimaryAndSecondaryCell";
static NSString *const CellIdentifierLEOCardTwoButtonPrimaryOnly = @"LEOTwoButtonPrimaryOnlyCell";
static NSString *const CellIdentifierLEOCardOneButtonSecondaryOnly = @"LEOOneButtonSecondaryOnlyCell";
static NSString *const CellIdentifierLEOCardOneButtonPrimaryAndSecondary = @"LEOOneButtonPrimaryAndSecondaryCell";
static NSString *const CellIdentifierLEOCardOneButtonPrimaryOnly = @"LEOOneButtonPrimaryOnlyCell";

static NSString *const kNotificationBookAppointment = @"requestToBookNewAppointment";
static NSString *const kNotificationManageSettings = @"requestToManageSettings";
static NSString *const kNotificationCardUpdated = @"Card-Updated";
static NSString *const kNotificationConversationAddedMessage = @"Conversation-AddedMessage";


#pragma mark - View Controller Lifecycle and VCL Helper Methods
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Registering as observer from one object
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:kNotificationBookAppointment
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceived:) name:kNotificationCardUpdated object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceived:) name:kNotificationConversationAddedMessage object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceived:) name:kNotificationManageSettings object:nil];

    [self tableViewSetup];
    [self pushNewMessageToConversation:[self conversation].associatedCardObject];
}

//MARK: Most likely doesn't belong in this class; no longer tied to it except for completion block which can be passed in.
- (void)pushNewMessageToConversation:(Conversation *)conversation {
    
    NSString *channelString = [NSString stringWithFormat:@"%@%@",@"newMessage",[SessionUser currentUser].email];
    NSString *event = @"new_message";
    
    LEOPusherHelper *pusherHelper = [LEOPusherHelper sharedPusher];
    [pusherHelper connectToPusherChannel:channelString withEvent:event sender:self withCompletion:^(NSDictionary *channelData) {
        
        [conversation addMessageFromJSON:channelData];
    }];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fetchDataForCard:nil];
}

- (void)notificationReceived:(NSNotification *)notification {
    
    if ([notification.name isEqualToString:kNotificationConversationAddedMessage] || [notification.name isEqualToString: @"Card-Updated"]) {
        [self fetchDataForCard:notification.object];
    }
    
    if ([notification.name isEqualToString:kNotificationBookAppointment]) {
        [self beginSchedulingNewAppointment];
    }
    
    if ([notification.name isEqualToString:kNotificationManageSettings]) {
        [self loadSettings];
    }
}

- (LEOCardConversation *)conversation {
    
    for (LEOCard *card in self.cards) {
        
        if ([card isKindOfClass:[LEOCardConversation class]]) {
            return (LEOCardConversation *)card;
        }
    }
    return nil; //Not loving this implementation since it technically *could* break...
}

- (void)fetchData {
    [self fetchDataForCard:nil];
}

- (void)fetchDataForCard:(LEOCard *)card {
    
    dispatch_queue_t queue = dispatch_queue_create("loadingQueue", NULL);
    
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    
    dispatch_async(queue, ^{
        
        LEOCardService *cardService = [[LEOCardService alloc] init];
        [cardService getCardsWithCompletion:^(NSArray *cards, NSError *error) {
            
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)takeResponsibilityForCard:(LEOCard *)card {
    card.delegate = self;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Card-Updated" object:nil]; //TODO: This method does not reflect the fact that an update has taken place. Consider naming differently, or moving this to a method that fits the bill?
}

- (void)didUpdateObjectStateForCard:(LEOCard *)card {
    
    [UIView animateWithDuration:0.2 animations:^{
        
    } completion:^(BOOL finished) {
        
        if (card.type == CardTypeAppointment) {
            
            Appointment *appointment = card.associatedCardObject; //FIXME: Make this a loop to account for multiple appointments.
            
            switch (appointment.statusCode) {
                case AppointmentStatusCodeNew:
                case AppointmentStatusCodeBooking:
                case AppointmentStatusCodeFuture: {
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

    Appointment *appointment = [[Appointment alloc] initWithObjectID:nil
                                                              date:nil
                                                   appointmentType:nil
                                                           patient:nil
                                                          provider:nil
                                                        practiceID:@"0"
                                                      bookedByUser:[SessionUser currentUser]
                                                              note:nil
                                                        statusCode:AppointmentStatusCodeNew];
    
    LEOCardAppointment *card = [[LEOCardAppointment alloc] initWithObjectID:@"temp" priority:@999 type:CardTypeAppointment associatedCardObject:appointment];
    
    [self loadBookingViewWithCard:card];
}

- (void)loadSettings {
    
    UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:kStoryboardSettings bundle:nil];
    UINavigationController *settingsNavController = [settingsStoryboard instantiateInitialViewController];
    LEOSettingsViewController *settingsVC = settingsNavController.viewControllers.firstObject;
    settingsVC.family = self.family;
    
    [self.navigationController pushViewController:settingsNavController animated:YES];
}


- (void)removeCard:(LEOCard *)card fromDatabaseWithCompletion:(void (^)(NSDictionary *response, NSError *error))completionBlock {
    
    //TODO: Include the progress hud while waiting for deletion.
    
    [self.appointmentService cancelAppointment:card.associatedCardObject withCompletion:^(NSDictionary * response, NSError * error) {
        if (completionBlock) {
            completionBlock(response, error);
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
    appointmentBookingVC.delegate = self;
    appointmentBookingVC.card = (LEOCardAppointment *)card;
                 self.transitionDelegate = [[LEOTransitioningDelegate alloc] init];
                appointmentNavController.transitioningDelegate = self.transitionDelegate;
                appointmentNavController.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:appointmentNavController animated:YES completion:^{
    }];
}



- (void)loadChattingViewWithCard:(LEOCard *)card {
    
    UIStoryboard *conversationStoryboard = [UIStoryboard storyboardWithName:@"Conversation" bundle:nil];
    UINavigationController *conversationNavController = [conversationStoryboard instantiateInitialViewController];
    LEOMessagesViewController *messagesVC = conversationNavController.viewControllers.firstObject;
    messagesVC.card = (LEOCardConversation *)card;
    
    self.transitionDelegate = [[LEOTransitioningDelegate alloc] init];
    conversationNavController.transitioningDelegate = self.transitionDelegate;
    conversationNavController.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:conversationNavController animated:YES completion:^{
        
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

-(LEOAppointmentService *)appointmentService {
    
    if (!_appointmentService) {
        _appointmentService = [[LEOAppointmentService alloc] init];
    }
    
    return _appointmentService;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

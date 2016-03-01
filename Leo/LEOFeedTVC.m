
//
//  LEOFeedTVC.m
//  Leo
//
//  Created by Zachary Drossman on 5/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOFeedTVC.h"
#import "LEOConstants.h"
#import <NSDate+DateTools.h>
#import "LEOCachedDataStore.h"
#import "ArrayDataSource.h"
#import "LEOCard.h"
#import "LEOCardConversation.h"

#import "LEOCardService.h"
#import "LEOHelperService.h"
#import "LEOAppointmentService.h"
#import "LEOFeedMessageService.h"

#import "User.h"
#import "Role.h"
#import "Appointment.h"
#import "Conversation.h"
#import "Message.h"
#import "Family.h"
#import "Practice.h"
#import "SessionUser.h"
#import "AppointmentStatus.h"

#import "UIColor+LeoColors.h"
#import "UIImage+Extensions.h"
#import "LEOExpandedCardAppointmentViewController.h"
#import "LEOMessagesViewController.h"
#import "LEOSettingsViewController.h"
#import "LEOPHRViewController.h"

#import "LEOCardAppointment.h"
#import "LEOTransitioningDelegate.h"

#import "LEOTwoButtonSecondaryOnlyCell+ConfigureForCell.h"
#import "LEOOneButtonSecondaryOnlyCell+ConfigureForCell.h"
#import "LEOTwoButtonPrimaryOnlyCell+ConfigureForCell.h"
#import "LEOOneButtonPrimaryOnlyCell+ConfigureForCell.h"
#import "LEOTwoButtonPrimaryAndSecondaryCell+ConfigureForCell.h"
#import "LEOOneButtonPrimaryAndSecondaryCell+ConfigureForCell.h"
#import "LEOFeedHeaderCell+ConfigureForCell.h"
#import "LEOFeedNavigationHeaderView.h"

#import <VBFPopFlatButton/VBFPopFlatButton.h>
#import "UIImageEffects.h"

#import "AppDelegate.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import "Configuration.h"
#import "LEOPusherHelper.h"

#import <UIImage+Resize.h>
#import "UIImageEffects.h"
#import <VBFPopFlatButton/VBFPopFlatButton.h>

#import "LEOStyleHelper.h"
#import "LEOValidationsHelper.h"
#import "LEOAppointmentViewController.h"
#import "UIViewController+XibAdditions.h"
#import "NSObject+TableViewAccurateEstimatedCellHeight.h"

typedef NS_ENUM(NSUInteger, TableViewSection) {
    TableViewSectionHeader,
    TableViewSectionBody,
    TableViewSectionCount,
};


@interface LEOFeedTVC ()

@property (nonatomic, strong) ArrayDataSource *cardsArrayDataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) LEOTransitioningDelegate *transitionDelegate;

@property (retain, nonatomic) NSMutableArray *cards;
@property (copy, nonatomic) NSArray *allStaff;
@property (copy, nonatomic) NSArray *appointmentTypes;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (strong, nonatomic) NSIndexPath *cardInFocusIndexPath;
@property (nonatomic) BOOL hasShownNewUserMessage;
@property (strong, nonatomic) LEOFeedNavigationHeaderView *feedNavigatorHeaderView;
@property (strong, nonatomic) NSString *headerMessage;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *grayView;

@end

@implementation LEOFeedTVC

static NSString *const CellIdentifierLEOCardTwoButtonSecondaryOnly = @"LEOTwoButtonSecondaryOnlyCell";
static NSString *const CellIdentifierLEOCardTwoButtonPrimaryAndSecondary = @"LEOTwoButtonPrimaryAndSecondaryCell";
static NSString *const CellIdentifierLEOCardTwoButtonPrimaryOnly = @"LEOTwoButtonPrimaryOnlyCell";
static NSString *const CellIdentifierLEOCardOneButtonSecondaryOnly = @"LEOOneButtonSecondaryOnlyCell";
static NSString *const CellIdentifierLEOCardOneButtonPrimaryAndSecondary = @"LEOOneButtonPrimaryAndSecondaryCell";
static NSString *const CellIdentifierLEOCardOneButtonPrimaryOnly = @"LEOOneButtonPrimaryOnlyCell";
static NSString *const kCellIdentifierLEOHeaderCell = @"LEOFeedHeaderCell";

static CGFloat const kFeedInsetTop = 20.0;


#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {

    [super viewDidLoad];

    self.view.tintColor = [UIColor leo_white];
    self.view.backgroundColor = [UIColor leo_orangeRed];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self setupNotifications];
    [self setNeedsStatusBarAppearanceUpdate];

    [self pushNewMessageToConversation:[self conversation].associatedCardObject];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    [self setupNavigationBar];

    if (!self.headerMessage) {
        self.headerMessage = @"Loading...";
    }

    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [LEOApiReachability startMonitoringForController:self withOfflineBlock:^{

        // TODO: Update message of header cell for when offline.

    } withOnlineBlock:^{
        [self fetchData];
    }];

    [self fetchData];
}


#pragma mark - Accessors

- (UIActivityIndicatorView *)activityIndicator {

    if (!_activityIndicator) {

        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.hidesWhenStopped = YES;
    }

    return _activityIndicator;
}

-(void)setGrayView:(UIView *)grayView {

    _grayView = grayView;
    _grayView.backgroundColor = [UIColor leo_grayForMessageBubbles];
}

- (void)setupNavigationBar {

    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [LEOStyleHelper styleNavigationBarForFeature:FeatureSettings];

    self.navigationBar.barTintColor = [UIColor leo_orangeRed];
    self.navigationBar.translucent = NO;

    CGSize imgSize = CGSizeMake(30.0, 30.0);
    UIImage *heartBBI = [[UIImage imageNamed:@"Icon-LeoHeart-Header"] resizedImageToSize:imgSize];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){.origin = CGPointZero, .size = imgSize}];
    imageView.image = heartBBI;

    UIImage *phrImage = [UIImage imageNamed:@"Icon-PHR"];
    UIButton *phrButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [phrButton setImage:phrImage forState:UIControlStateNormal];
    phrButton.frame = (CGRect){.origin = CGPointZero, .size = imgSize};
    [phrButton addTarget:self action:@selector(phrTouchedUpInside) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *phrBBI = [[UIBarButtonItem alloc] initWithCustomView:phrButton];

    UIImage *settingsImage = [UIImage imageNamed:@"Icon-Settings"];
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton setImage:settingsImage forState:UIControlStateNormal];
    settingsButton.frame = (CGRect){.origin = CGPointZero, .size = imgSize};
    [settingsButton addTarget:self action:@selector(loadSettings) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingsBBI = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];

    self.navigationBar.topItem.title = @"";
    UINavigationItem *item = [UINavigationItem new];
    item.rightBarButtonItem = phrBBI;
    item.leftBarButtonItem = settingsBBI;
    item.titleView = imageView;
    self.navigationBar.items = @[item];
}


#pragma mark - Actions
    
- (void)phrTouchedUpInside {

    LEOPHRViewController *phrViewController = [[LEOPHRViewController alloc] initWithPatients:self.family.patients];

    // Without this line, the view ends up getting resized to 0 height, and does not appear (for searching: black screen push animated)
    phrViewController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:phrViewController animated:YES];
}

- (void)fetchFeedHeader {

    LEOFeedMessageService *feedMessageService = [LEOFeedMessageService new];

    [feedMessageService getFeedMessageForDate:[NSDate date] withCompletion:^(NSString *feedMessage, NSError *error) {

        self.headerMessage = feedMessage;

        dispatch_async(dispatch_get_main_queue() , ^{

            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:TableViewSectionHeader];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        });
    }];
}


- (void)setupNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:kNotificationCardUpdated
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:kNotificationConversationAddedMessage
                                               object:nil];
}

- (void)removeObservers {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationCardUpdated object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationConversationAddedMessage object:nil];
}

- (void)dealloc {

    [self removeObservers];
}

//MARK: Most likely doesn't belong in this class; no longer tied to it except for completion block which can be passed in.
- (void)pushNewMessageToConversation:(Conversation *)conversation {

    NSString *channelString = [NSString stringWithFormat:@"%@",[SessionUser currentUser].objectID];
    NSString *event = @"new_message";

    LEOPusherHelper *pusherHelper = [LEOPusherHelper sharedPusher];

    [pusherHelper connectToPusherChannel:channelString
                               withEvent:event
                                  sender:self
                          withCompletion:^(NSDictionary *channelData) {

                              [conversation addMessageFromJSON:channelData];
                          }];
}

- (void)fetchFamilyWithCompletion:( void (^) (void))completionBlock {

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    LEOHelperService *helperService = [LEOHelperService new];
    [helperService getFamilyWithCompletion:^(Family *family, NSError *error) {

        if (!error) {
            self.family = family;
            completionBlock();
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

- (void)notificationReceived:(NSNotification *)notification {

    if ([notification.name isEqualToString:kNotificationConversationAddedMessage] || [notification.name isEqualToString: @"Card-Updated"]) {
        [self fetchDataForCard:notification.object];
    }
}

- (LEOCardConversation *)conversation {

    for (id<LEOCardProtocol>card in self.cards) {

        if ([card isKindOfClass:[LEOCardConversation class]]) {
            return (LEOCardConversation *)card;
        }
    }
    return nil; //MARK: Not loving this implementation since it technically *could* break...
}

- (void)fetchData {

    [self fetchFeedHeader];
    [self fetchFamilyWithCompletion:^{

        // refresh cached practice
        if (![[LEOCachedDataStore sharedInstance].lastCachedDateForPractice isSameDay:[NSDate date]] || ![LEOCachedDataStore sharedInstance].practice) {
            [[LEOHelperService new] getPracticesWithCompletion:^(NSArray *practices, NSError *error) {
                [self fetchDataForCard:nil];
            }];
        } else {
            [self fetchDataForCard:nil];
        }
    }];
}

- (void)fetchDataForCard:(id<LEOCardProtocol>)card {

    dispatch_queue_t queue = dispatch_queue_create("loadingQueue", NULL);

    dispatch_async(queue, ^{

        LEOCardService *cardService = [LEOCardService new];
        [cardService getCardsWithCompletion:^(NSArray *cards, NSError *error) {

            if (!error) {
                self.cards = [cards mutableCopy];
            }

            dispatch_async(dispatch_get_main_queue() , ^{

                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionBody] withRowAnimation:UITableViewRowAnimationNone];
                [MBProgressHUD hideHUDForView:self.view animated:NO];

                [self activateCardInFocus];

                [self promptUserToFillProfileIfNeeded];

            });
        }];
    });
}

- (void)promptUserToFillProfileIfNeeded {

    if ([[SessionUser currentUser] numTimesLoggedIn] == 1 && !self.hasShownNewUserMessage) {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Welcome to Leo at Flatiron Pediatrics!" message:@"First things first, please visit Settings to add a photo of your child and invite another parent/guardian!" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Go to Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            [self loadSettings];
        }]];
        [self presentViewController:alert animated:YES completion:nil];

        self.hasShownNewUserMessage = YES;
    }
}

- (NSIndexPath *)cardInFocusIndexPath {

    if (!_cardInFocusIndexPath) {
        _cardInFocusIndexPath = [self indexPathForCardWithCardType:self.cardInFocusType underlyingObjectID:self.cardInFocusObjectID];
    }
    return _cardInFocusIndexPath;
}

- (NSIndexPath*)indexPathForCardWithCardType:(CardType)cardType underlyingObjectID:(NSString*)objectID {

    if (!objectID || cardType == CardTypeUndefined) {
        return nil;
    }

    int i = 0;
    NSIndexPath *indexPath;
    for (LEOCard *card in self.cards) {
        if (card.type == cardType) {
            //             ????: TODO: create a protocol for associatedCardObjects
            if ([card.associatedCardObject respondsToSelector:@selector(objectID)]) {
                NSString *objectIDString = (NSString *)[card.associatedCardObject objectID];
                if ([objectIDString isEqual:objectID]) {
                    indexPath = [NSIndexPath indexPathForItem:i inSection:TableViewSectionBody];
                }
            }
        }
        i++;
    }
    return indexPath;
}

- (void)activateCardInFocus {

    [self.tableView scrollToRowAtIndexPath:self.cardInFocusIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];

    [self animateCellHighlight];

}

- (void)animateCellHighlight {

    LEOFeedCell *cell = [self.tableView cellForRowAtIndexPath:self.cardInFocusIndexPath];
    [cell setUnreadState:YES animated:YES];
}

-(void)setTableView:(UITableView *)tableView {

    _tableView = tableView;

    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [_tableView registerNib:[LEOTwoButtonPrimaryOnlyCell nib]
         forCellReuseIdentifier:CellIdentifierLEOCardTwoButtonPrimaryOnly];

    [_tableView registerNib:[LEOOneButtonPrimaryOnlyCell nib]
         forCellReuseIdentifier:CellIdentifierLEOCardOneButtonPrimaryOnly];

    [_tableView registerNib:[LEOTwoButtonSecondaryOnlyCell nib]
         forCellReuseIdentifier:CellIdentifierLEOCardTwoButtonSecondaryOnly];

    [_tableView registerNib:[LEOOneButtonSecondaryOnlyCell nib]
         forCellReuseIdentifier:CellIdentifierLEOCardOneButtonSecondaryOnly];

    [_tableView registerNib:[LEOTwoButtonPrimaryAndSecondaryCell nib]
         forCellReuseIdentifier:CellIdentifierLEOCardTwoButtonPrimaryAndSecondary];

    [_tableView registerNib:[LEOOneButtonPrimaryAndSecondaryCell nib]
         forCellReuseIdentifier:CellIdentifierLEOCardOneButtonPrimaryAndSecondary];

    [_tableView registerNib:[LEOFeedHeaderCell nib]
         forCellReuseIdentifier:kCellIdentifierLEOHeaderCell];
}



#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)takeResponsibilityForCard:(id<LEOCardProtocol>)card {

    card.activityDelegate = self;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCardUpdated object:nil]; //TODO: This method does not reflect the fact that an update has taken place. Consider naming differently, or moving this to a method that fits the bill?
}

- (void)didUpdateObjectStateForCard:(id<LEOCardProtocol>)card {


    [UIView animateWithDuration:0.2 animations:^{

    } completion:^(BOOL finished) {

        if ([card isKindOfClass:[LEOCardAppointment class]]) {

            Appointment *appointment = card.associatedCardObject; //FIXME: Make this a loop to account for multiple appointments.

            switch (appointment.status.statusCode) {
                case AppointmentStatusCodeNew:
                case AppointmentStatusCodeBooking:
                case AppointmentStatusCodeFuture: {

                    [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"%s appointment future", __PRETTY_FUNCTION__]];

                    [self loadBookingViewWithCard:card];
                    break;
                }

                case AppointmentStatusCodeCancelled: {

                    [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"%s appointment cancelled", __PRETTY_FUNCTION__]];

                    [self removeCardFromFeed:card];
                    break;
                }

                case AppointmentStatusCodeCancelling: {

                    [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"%s appointment cancelling", __PRETTY_FUNCTION__]];

                    [self.tableView reloadData];
                    break;
                }

                case AppointmentStatusCodeConfirmingCancelling: {

                    [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"%s appointment confirming cancelling", __PRETTY_FUNCTION__]];

                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[((LEOCard *)card).priority integerValue] inSection:TableViewSectionBody];
                    LEOFeedCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

                    dispatch_async(dispatch_get_main_queue(), ^{
                        [cell.contentView addSubview:self.activityIndicator];

                        CGRect frame = CGRectMake(CGRectGetMaxX(cell.frame) - 20, CGRectGetMinY(cell.frame) + 20, 40, 40);
                        self.activityIndicator.frame = frame;
                        [self.activityIndicator startAnimating];
                    });

                    [self removeCard:card fromDatabaseWithCompletion:^(NSDictionary *response, NSError *error) {

                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.activityIndicator stopAnimating];
                            [self.activityIndicator removeFromSuperview];
                        });

                        if (!error) {

                            [self.tableView reloadData];
                        } else {

                            [card.associatedCardObject undoIfAvailable];
                        }
                    }];

                    break;
                }

                case AppointmentStatusCodeReminding: {

                    [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"%s appointment reminding", __PRETTY_FUNCTION__]];

                    [self.tableView reloadData];
                    break;
                }

                case AppointmentStatusCodeChargeEntered:
                case AppointmentStatusCodeCheckedIn:
                case AppointmentStatusCodeCheckedOut:
                case AppointmentStatusCodeOpen:
                case AppointmentStatusCodeRecommending:
                case AppointmentStatusCodeUndefined: {

                    [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"%s appointment status undefined", __PRETTY_FUNCTION__]];

                    [self.tableView reloadData]; //TODO: This is not right, but for now it is a placeholder.
                    break;
                }
            }
        }
        if ([card isKindOfClass:[LEOCardConversation class]]) {

            Conversation *conversation = card.associatedCardObject; //FIXME: Make this a loop to account for multiple appointments.

            switch (conversation.statusCode) {

                case ConversationStatusCodeClosed: {

                    [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"%s conversation closed", __PRETTY_FUNCTION__]];
                    [self.tableView reloadData];
                    break;
                }
                case ConversationStatusCodeOpen: {

                    [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"%s conversation open", __PRETTY_FUNCTION__]];
                    [self loadChattingViewWithCard:card];
                    break;
                }

                case ConversationStatusCodeNewMessages:
                case ConversationStatusCodeReadMessages:
                case ConversationStatusCodeCallUs:
                    [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"%s conversation call us", __PRETTY_FUNCTION__]];
                    [self confirmCallUs];
                case ConversationStatusCodeUndefined:
                    [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"%s conversation undefined", __PRETTY_FUNCTION__]];
                    break;
            }
        }
    }];
}

- (void)confirmCallUs {

    NSString *practiceName = @"Flatiron Pediatrics"; // FIXME: where is the practice object stored?
    NSString *alertTitle = [NSString stringWithFormat:@"You are about to call \n%@\n%@", practiceName,
                            [LEOValidationsHelper formattedPhoneNumberFromPhoneNumber:kFlatironPediatricsPhoneNumber]];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Call" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *phoneCallNum = [NSString stringWithFormat:@"tel://%@",kFlatironPediatricsPhoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneCallNum]];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)beginSchedulingNewAppointment {

    AppointmentStatus *appointmentStatus = [AppointmentStatus new];
    appointmentStatus.statusCode = AppointmentStatusCodeFuture;

    Patient *patient;
    if (self.family.patients.count == 1) {
        patient = [self.family.patients firstObject];
    }

    Appointment *appointment = [[Appointment alloc] initWithObjectID:nil
                                                                date:nil
                                                     appointmentType:nil
                                                             patient:patient
                                                            provider:nil
                                                          practiceID:@"0"
                                                        bookedByUser:[SessionUser currentUser]
                                                                note:nil
                                                              status:appointmentStatus];

    LEOCardAppointment *card = [[LEOCardAppointment alloc] initWithObjectID:@"999" priority:@0 associatedCardObject:appointment];

    [self loadBookingViewWithCard:card];
}

- (void)loadSettings {

    UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:kStoryboardSettings
                                                                 bundle:nil];

    LEOSettingsViewController *settingsVC = [settingsStoryboard instantiateInitialViewController];
    settingsVC.family = self.family;

    [self.navigationController pushViewController:settingsVC animated:YES];
}


- (void)removeCard:(LEOCard *)card fromDatabaseWithCompletion:(void (^)(NSDictionary *response, NSError *error))completionBlock {

    //TODO: Include the progress hud while waiting for deletion.

    [[LEOAppointmentService new] cancelAppointment:card.associatedCardObject
                                withCompletion:^(NSDictionary * response, NSError * error) {

                                    if (completionBlock) {
                                        completionBlock(response, error);
                                    }
                                }];
}

- (void)removeCardFromFeed:(LEOCard *)card {

    [self.tableView beginUpdates];
    NSUInteger cardRow = [self.cards indexOfObject:card];
    [self removeCard:card];

    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:cardRow
                                               inSection:TableViewSectionBody]];

    [self.tableView deleteRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];

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


- (void)loadBookingViewWithCard:(LEOCardAppointment *)card {

    UIStoryboard *appointmentStoryboard = [UIStoryboard storyboardWithName:@"Appointment"
                                                                    bundle:nil];

    UINavigationController *appointmentNavController = [appointmentStoryboard instantiateInitialViewController];
    self.transitionDelegate = [[LEOTransitioningDelegate alloc] initWithTransitionAnimatorType:TransitionAnimatorTypeCardModal];
    appointmentNavController.transitioningDelegate = self.transitionDelegate;

    appointmentNavController.modalPresentationStyle = UIModalPresentationFullScreen;

    LEOAppointmentViewController *appointmentBookingVC = appointmentNavController.viewControllers.firstObject;

    appointmentBookingVC.card = (LEOCardAppointment *)card;
    appointmentBookingVC.delegate = self;

    [self presentViewController:appointmentNavController animated:YES completion:nil];
}


- (void)loadChattingViewWithCard:(LEOCard *)card {

    UIStoryboard *conversationStoryboard = [UIStoryboard storyboardWithName:@"Conversation" bundle:nil];
    UINavigationController *conversationNavController = [conversationStoryboard instantiateInitialViewController];
    LEOMessagesViewController *messagesVC = conversationNavController.viewControllers.firstObject;
    messagesVC.card = (LEOCardConversation *)card;

    self.transitionDelegate = [[LEOTransitioningDelegate alloc] initWithTransitionAnimatorType:TransitionAnimatorTypeCardModal];
    conversationNavController.transitioningDelegate = self.transitionDelegate;
    conversationNavController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:conversationNavController animated:YES completion:^{
    }];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return TableViewSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section) {
        case TableViewSectionHeader:
            return 1;

        case TableViewSectionBody:
            return self.cards.count;

        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self leo_tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    switch (indexPath.section) {
        case TableViewSectionHeader:
            return [self tableView:tableView cellForHeaderRowAtIndexPath:indexPath];

        case TableViewSectionBody:
            return [self tableView:tableView cellForBodyRowAtIndexPath:indexPath];

        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForHeaderRowAtIndexPath:(NSIndexPath *)indexPath {

    LEOFeedHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierLEOHeaderCell forIndexPath:indexPath];

    [cell configureForCurrentUserWithMessage:self.headerMessage];

    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForBodyRowAtIndexPath:(NSIndexPath *)indexPath {

    id<LEOCardProtocol>card = self.cards[indexPath.row];
    card.activityDelegate = self;

    NSString *cellIdentifier;

    switch (card.layout) {

        case CardLayoutTwoButtonSecondaryOnly: {
            cellIdentifier = CellIdentifierLEOCardTwoButtonSecondaryOnly;
            break;
        }

        case CardLayoutOneButtonSecondaryOnly: {
            cellIdentifier = CellIdentifierLEOCardOneButtonSecondaryOnly;
            break;
        }

        case CardLayoutTwoButtonPrimaryOnly: {
            cellIdentifier = CellIdentifierLEOCardTwoButtonPrimaryOnly;
            break;
        }

        case CardLayoutOneButtonPrimaryOnly: {
            cellIdentifier = CellIdentifierLEOCardOneButtonPrimaryOnly;
            break;
        }

        case CardLayoutTwoButtonPrimaryAndSecondary: {
            cellIdentifier = CellIdentifierLEOCardTwoButtonPrimaryAndSecondary;
            break;
        }

        case CardLayoutOneButtonPrimaryAndSecondary: {
            cellIdentifier = CellIdentifierLEOCardOneButtonPrimaryAndSecondary;
            break;
        }

        case CardLayoutUndefined: {
            //TODO: Should deal with this as an error of some sort.
            return nil;
        }
    }

    LEOFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                        forIndexPath:indexPath];;

    [cell configureForCard:card];
    cell.unreadState = [indexPath isEqual:self.cardInFocusIndexPath];

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    switch (section) {
        case TableViewSectionHeader:
            return nil;

        case TableViewSectionBody:
            return self.feedNavigatorHeaderView;

        default:
            return nil;
    }
}

- (LEOFeedNavigationHeaderView *)feedNavigatorHeaderView {

    if (!_feedNavigatorHeaderView) {

        _feedNavigatorHeaderView = [LEOFeedNavigationHeaderView new];

        _feedNavigatorHeaderView.backgroundColor = [UIColor leo_white];

        _feedNavigatorHeaderView.delegate = self;
    }

    return _feedNavigatorHeaderView;
}

- (void)bookAppointmentTouchedUpInside {

    [self beginSchedulingNewAppointment];
}

- (void)messageUsTouchedUpInside {

    LEOCardConversation *conversationCard = [self findConversationCard];
    [self loadChattingViewWithCard:conversationCard];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    switch (section) {
            
        case TableViewSectionBody:
            return 45;
            
        case TableViewSectionHeader:
        default:
            return CGFLOAT_MIN;
    }
}

- (LEOCardConversation *)findConversationCard {
    
    for (LEOCard *card in self.cards) {
        
        if ([card isKindOfClass:[LEOCardConversation class]]) {
            return (LEOCardConversation *)card;
        }
    }
    
    return nil;
}

- (void)showSomethingWentWrong {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops! Looks like we had a boo boo." message:@"We're working on a fix. Check back later!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


@end

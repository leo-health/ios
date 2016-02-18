
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
#import "LEOHelperService.h"
#import "LEOAppointmentService.h"

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

#import <VBFPopFlatButton/VBFPopFlatButton.h>
#import "UIImageEffects.h"

#import "AppDelegate.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import "Configuration.h"
#import "LEOPusherHelper.h"
#import "MenuView.h"

#import <UIImage+Resize.h>
#import "UIImageEffects.h"
#import <VBFPopFlatButton/VBFPopFlatButton.h>

#import "LEOStyleHelper.h"
#import "LEOValidationsHelper.h"
#import "LEOAppointmentViewController.h"
#import "UIViewController+XibAdditions.h"
#import "NSObject+TableViewAccurateEstimatedCellHeight.h"


@interface LEOFeedTVC ()

@property (strong, nonatomic) LEOAppointmentService *appointmentService;

@property (nonatomic, strong) ArrayDataSource *cardsArrayDataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) LEOTransitioningDelegate *transitionDelegate;

@property (retain, nonatomic) NSMutableArray *cards;
@property (copy, nonatomic) NSArray *allStaff;
@property (copy, nonatomic) NSArray *appointmentTypes;

@property (weak, nonatomic) IBOutlet VBFPopFlatButton *menuButton;
@property (nonatomic) BOOL menuShowing;
@property (strong, nonatomic) UIImageView *blurredImageView;
@property (strong, nonatomic) MenuView *menuView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (strong, nonatomic) NSIndexPath *cardInFocusIndexPath;


@end

@implementation LEOFeedTVC

static NSString *const CellIdentifierLEOCardTwoButtonSecondaryOnly = @"LEOTwoButtonSecondaryOnlyCell";
static NSString *const CellIdentifierLEOCardTwoButtonPrimaryAndSecondary = @"LEOTwoButtonPrimaryAndSecondaryCell";
static NSString *const CellIdentifierLEOCardTwoButtonPrimaryOnly = @"LEOTwoButtonPrimaryOnlyCell";
static NSString *const CellIdentifierLEOCardOneButtonSecondaryOnly = @"LEOOneButtonSecondaryOnlyCell";
static NSString *const CellIdentifierLEOCardOneButtonPrimaryAndSecondary = @"LEOOneButtonPrimaryAndSecondaryCell";
static NSString *const CellIdentifierLEOCardOneButtonPrimaryOnly = @"LEOOneButtonPrimaryOnlyCell";

static NSString *const kNotificationCardUpdated = @"Card-Updated";
static NSString *const kNotificationConversationAddedMessage = @"Conversation-AddedMessage";

static CGFloat const kFeedInsetTop = 30.0;

#pragma mark - View Controller Lifecycle and VCL Helper Methods
- (void)viewDidLoad {

    [super viewDidLoad];

    self.view.tintColor = [UIColor leo_white];
    self.view.backgroundColor = [UIColor leo_orangeRed];

    [self setupNotifications];
    [self setupTableView];
    [self setupMenuButton];
    [self setNeedsStatusBarAppearanceUpdate];

    [self pushNewMessageToConversation:[self conversation].associatedCardObject];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    [self setupNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [LEOApiReachability startMonitoringForController:self withOfflineBlock:^{

        self.menuButton.tintColor = [UIColor leo_grayForPlaceholdersAndLines];
        self.menuButton.backgroundColor = [UIColor leo_grayStandard];
        // TODO: what should happen when the user is offline?
    } withOnlineBlock:^{

        self.menuButton.tintColor = [UIColor leo_white];
        self.menuButton.backgroundColor = [UIColor leo_orangeRed];

        [self fetchFamilyWithCompletion:^{

            [self fetchDataForCard:nil];
        }];
    }];
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

- (void)phrTouchedUpInside {

    LEOPHRViewController *phrViewController = [[LEOPHRViewController alloc] initWithPatients:self.family.patients];

    // Without this line, the view ends up getting resized to 0 height, and does not appear (for searching: black screen push animated)
    phrViewController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:phrViewController animated:YES];
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

    if (!self.family) {

        LEOHelperService *helperService = [LEOHelperService new];
        [helperService getFamilyWithCompletion:^(Family *family, NSError *error) {

            if (!error) {
                self.family = family;
                completionBlock();
            }
        }];
    } else {
        completionBlock();
    }
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
    [self fetchDataForCard:nil];
}

- (void)fetchDataForCard:(id<LEOCardProtocol>)card {

    dispatch_queue_t queue = dispatch_queue_create("loadingQueue", NULL);

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    dispatch_async(queue, ^{

        LEOCardService *cardService = [LEOCardService new];
        [cardService getCardsWithCompletion:^(NSArray *cards, NSError *error) {

            if (!error) {
                self.cards = [cards mutableCopy];
            }

            dispatch_async(dispatch_get_main_queue() , ^{

                [self.tableView reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:NO];

                [self activateCardInFocus];
            });
        }];
    });
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
                    indexPath = [NSIndexPath indexPathForItem:i inSection:0];
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

- (void)setupTableView {

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = [UIColor leo_grayForMessageBubbles];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    UIEdgeInsets insets = self.tableView.contentInset;
    insets.top += kFeedInsetTop;
    self.tableView.contentInset = insets;

    [self.tableView registerNib:[LEOTwoButtonPrimaryOnlyCell nib]
         forCellReuseIdentifier:CellIdentifierLEOCardTwoButtonPrimaryOnly];

    [self.tableView registerNib:[LEOOneButtonPrimaryOnlyCell nib]
         forCellReuseIdentifier:CellIdentifierLEOCardOneButtonPrimaryOnly];

    [self.tableView registerNib:[LEOTwoButtonSecondaryOnlyCell nib]
         forCellReuseIdentifier:CellIdentifierLEOCardTwoButtonSecondaryOnly];

    [self.tableView registerNib:[LEOOneButtonSecondaryOnlyCell nib]
         forCellReuseIdentifier:CellIdentifierLEOCardOneButtonSecondaryOnly];

    [self.tableView registerNib:[LEOTwoButtonPrimaryAndSecondaryCell nib]
         forCellReuseIdentifier:CellIdentifierLEOCardTwoButtonPrimaryAndSecondary];

    [self.tableView registerNib:[LEOOneButtonPrimaryAndSecondaryCell nib]
         forCellReuseIdentifier:CellIdentifierLEOCardOneButtonPrimaryAndSecondary];
}



#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)takeResponsibilityForCard:(id<LEOCardProtocol>)card {

    card.activityDelegate = self;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Card-Updated" object:nil]; //TODO: This method does not reflect the fact that an update has taken place. Consider naming differently, or moving this to a method that fits the bill?
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

                            [card.associatedCardObject undoIfAvailable];
                        }
                    }];

                    break;
                }

                case AppointmentStatusCodeReminding: {

                    [self.tableView reloadData];
                    break;
                }

                case AppointmentStatusCodeChargeEntered:
                case AppointmentStatusCodeCheckedIn:
                case AppointmentStatusCodeCheckedOut:
                case AppointmentStatusCodeOpen:
                case AppointmentStatusCodeRecommending:
                case AppointmentStatusCodeUndefined: {
                    [self.tableView reloadData]; //TODO: This is not right, but for now it is a placeholder.
                    break;
                }
            }
        }
        if ([card isKindOfClass:[LEOCardConversation class]]) {

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

                case ConversationStatusCodeNewMessages:
                case ConversationStatusCodeReadMessages:
                case ConversationStatusCodeCallUs:
                    [self confirmCallUs];
                case ConversationStatusCodeUndefined:
                    break;

                    //FIXME: Need to handle "Call us" somehow
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

    [self.appointmentService cancelAppointment:card.associatedCardObject
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
                                               inSection:0]];

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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cards.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [self leo_tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

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

-(LEOAppointmentService *)appointmentService {

    if (!_appointmentService) {
        _appointmentService = [LEOAppointmentService new];
    }

    return _appointmentService;
}


/**
 *  Create a blurred version of the current view. Does not blur status bar currently.
 *
 *  @return the blurred UIImage
 */
-(UIImage *)blurredSnapshot {

    self.menuButton.hidden = YES;
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, NO, 0);

    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];

    //    [self.view drawViewHierarchyInRect:[UIScreen mainScreen].bounds afterScreenUpdates:YES];

    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();

    UIImage *blurredSnapshotImage = [UIImageEffects imageByApplyingBlurToImage:snapshotImage withRadius:4 tintColor:nil saturationDeltaFactor:1.0 maskImage:nil];

    UIGraphicsEndImageContext();

    self.menuButton.hidden = NO;
    return blurredSnapshotImage;
}


/**
 *  Initialize VBFPopFlatButton for menu with appropriate values for key properties.
 */
- (void)setupMenuButton {

    self.menuButton.currentButtonType = buttonAddType;
    self.menuButton.currentButtonStyle = buttonRoundedStyle;
    self.menuButton.tintColor = [UIColor leo_white];
    self.menuButton.roundBackgroundColor = [UIColor leo_orangeRed];
    self.menuButton.lineThickness = 1;
    [self.menuButton addTarget:self action:@selector(menuTapped) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  Toggle method for blur and menu animation when `menuButton` is tapped.
 */
- (void)menuTapped {

    if (!self.menuShowing) {

        [self initializeMenuView];
        [self animateMenuLoad];
    } else {

        [self animateMenuDisappearWithCompletion:^{
            [self dismissMenuView];
        }];
    }

    self.menuShowing = !self.menuShowing;
}


/**
 *  Load Main Menu for Leo. Includes blurred background and updated menu button.
 */
- (void)animateMenuLoad {

    UIImage *blurredView = [self blurredSnapshot];
    self.blurredImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    self.blurredImageView.image = blurredView;
    [self.view insertSubview:self.blurredImageView
                belowSubview:self.menuView];
    [self.menuButton animateToType:buttonCloseType];
    self.menuButton.roundBackgroundColor = [UIColor clearColor];
    self.menuButton.tintColor = [UIColor leo_orangeRed];


    self.blurredImageView.alpha = 0;

    [UIView animateWithDuration:0.25 animations:^{

        self.menuView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.5];

        self.menuView.alpha = 0.8;
        self.blurredImageView.alpha = 1;
        [self.menuButton layoutIfNeeded];
        [self.menuView layoutIfNeeded];
    }];
}


/**
 *  Unload main menu. Includes blurred background and updated menu button.
 */
- (void)animateMenuDisappearWithCompletion:(void (^)(void))completionBlock {

    [self.menuButton animateToType:buttonAddType];
    self.menuButton.roundBackgroundColor = [UIColor leo_orangeRed];
    self.menuButton.tintColor = [UIColor leo_white];
    self.blurredImageView.alpha = 1;

    [UIView animateWithDuration:0.25 animations:^{

        self.blurredImageView.alpha = 0;
        self.menuView.alpha = 0;
        [self.menuButton layoutIfNeeded];
        [self.menuView layoutIfNeeded];

    } completion:^(BOOL finished) {

        [self.blurredImageView removeFromSuperview];

        if (completionBlock) {
            completionBlock();
        }
    }];
}


/**
 *  Layout and set initial state of main menu.
 */
- (void)initializeMenuView {

    self.menuView = [self leo_loadViewFromNibForClass:[MenuView class]];
    self.menuView.alpha = 0;
    self.menuView.translatesAutoresizingMaskIntoConstraints = NO;
    self.menuView.delegate = self;

    [self.view insertSubview:self.menuView belowSubview:self.menuButton];

    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_menuView);

    NSArray *horizontalMenuViewLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_menuView]|" options:0 metrics:nil views:viewsDictionary];

    NSArray *verticalMenuViewLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_menuView]|" options:0 metrics:nil views:viewsDictionary];

    [self.view addConstraints:horizontalMenuViewLayoutConstraints];
    [self.view addConstraints:verticalMenuViewLayoutConstraints];
    [self.view layoutIfNeeded];
}

/**
 *  Remove menu view from superview and clear it from memory.
 */
- (void)dismissMenuView {

    [self.menuView removeFromSuperview];
    self.menuShowing = NO;
    self.menuView = nil;
}

-(void)didMakeMenuChoice:(MenuChoice)menuChoice {

    [self animateMenuDisappearWithCompletion:^{
        [self dismissMenuView];
    }];

    switch (menuChoice) {

        case MenuChoiceScheduleAppointment:
            [self beginSchedulingNewAppointment];
            break;

        case MenuChoiceChat: {

            LEOCardConversation *conversationCard = [self findConversationCard];

            if (conversationCard) {
                [self loadChattingViewWithCard:conversationCard];
            } else {
                [self showSomethingWentWrong];
            }
            
            break;
        }
            
        case MenuChoiceSubmitAForm:
            break;
            
        case MenuChoiceUndefined:
            break;
            
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

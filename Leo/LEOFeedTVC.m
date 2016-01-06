
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
#import "LEOAppointmentViewController.h"



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


#pragma mark - View Controller Lifecycle and VCL Helper Methods
- (void)viewDidLoad {

    [super viewDidLoad];

    self.view.tintColor = [UIColor leo_white];
    self.view.backgroundColor = [UIColor leo_orangeRed];

    [self setupNavigationBar];

    [self setupNotifications];
    [self setupTableView];
    [self setupMenuButton];
    [self setNeedsStatusBarAppearanceUpdate];

    [self pushNewMessageToConversation:[self conversation].associatedCardObject];
    [LEOApiReachability startMonitoringForController:self];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    [LEOStyleHelper styleNavigationBarForFeature:FeatureSettings];

    self.navigationController.navigationBarHidden = YES;
}

- (void)setupNavigationBar {

    self.navigationBar.barTintColor = [UIColor leo_orangeRed];
    self.navigationBar.translucent = NO;

    [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];

    UIImage *heartBBI = [[UIImage imageNamed:@"Icon-LeoHeart-Header"] resizedImageToSize:CGSizeMake(30.0, 30.0)];

    UIBarButtonItem *leoheartBBI = [[UIBarButtonItem alloc] initWithImage:heartBBI style:UIBarButtonItemStylePlain target:self action:nil];

    UIImage *phrImage = [[UIImage imageNamed:@"Icon-PHR"] resizedImageToSize:CGSizeMake(30.0, 30.0)];

    UIBarButtonItem *phrBBI = [[UIBarButtonItem alloc] initWithImage:phrImage style:UIBarButtonItemStylePlain target:self action:@selector(phrTouchedUpInside)];

    self.navigationBar.topItem.title = @"";

    UINavigationItem *item = [UINavigationItem new];

    item.leftBarButtonItem = leoheartBBI;
    item.rightBarButtonItem = phrBBI;

    self.navigationBar.items = @[item];
}

- (void)phrTouchedUpInside {

    LEOPHRViewController *phrViewController = [[LEOPHRViewController alloc] initWithPatients:self.family.patients];
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

    NSString *channelString = [NSString stringWithFormat:@"%@%@",@"newMessage",[SessionUser currentUser].email];
    NSString *event = @"new_message";

    LEOPusherHelper *pusherHelper = [LEOPusherHelper sharedPusher];

    [pusherHelper connectToPusherChannel:channelString
                               withEvent:event
                                  sender:self
                          withCompletion:^(NSDictionary *channelData) {

                              [conversation addMessageFromJSON:channelData];
                          }];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [self fetchFamilyWithCompletion:^{

        [self fetchDataForCard:nil];
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

    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];

    dispatch_async(queue, ^{

        LEOCardService *cardService = [LEOCardService new];
        [cardService getCardsWithCompletion:^(NSArray *cards, NSError *error) {

            if (!error) {
                self.cards = [cards mutableCopy];
            }

            dispatch_async(dispatch_get_main_queue() , ^{

                [self.tableView reloadData];

                //                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.cardInFocus inSection:0];
                //                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];

                [MBProgressHUD hideHUDForView:self.tableView animated:YES];
            });
        }];
    });
}

- (void)setupTableView {

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = [UIColor leo_grayForMessageBubbles];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    UIEdgeInsets insets = self.tableView.contentInset;
    insets.top += 24;
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
                case ConversationStatusCodeUndefined:
                    break;

                    //FIXME: Need to handle "Call us" somehow
            }
        }
    }];
}

- (void)beginSchedulingNewAppointment {

    AppointmentStatus *appointmentStatus = [AppointmentStatus new];
    appointmentStatus.statusCode = AppointmentStatusCodeFuture;

    Appointment *appointment = [[Appointment alloc] initWithObjectID:nil
                                                                date:nil
                                                     appointmentType:nil
                                                             patient:nil
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
    appointmentNavController.modalPresentationStyle = UIModalPresentationCustom;

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
    conversationNavController.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:conversationNavController animated:YES completion:^{

    }];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.cards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    id<LEOCardProtocol>card = self.cards[indexPath.row];
    card.activityDelegate = self;

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

    self.menuView = [MenuView new];
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

    [self viewWillAppear:YES];

    [self.menuView removeFromSuperview];
    self.menuView = nil;

    [self viewDidAppear:YES];
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
            
        case MenuChoiceUpdateSettings:
            [self loadSettings];
            break;
            
        case MenuChoiceUndefined:
            break;
            
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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

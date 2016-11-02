
//
//  LEOFeedTVC.m
//  Leo
//
//  Created by Zachary Drossman on 5/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Leo-Swift.h"
#import "LEOFeedTVC.h"
#import "LEOConstants.h"
#import <NSDate+DateTools.h>
#import "LEOUserService.h"
#import "ArrayDataSource.h"
#import "LEOCard.h"
#import "LEOCardConversation.h"
#import "Guardian.h"

#import "LEOCardService.h"
#import "LEOPracticeService.h"
#import "LEOFamilyService.h"
#import "LEOAppointmentService.h"
#import "LEONoticeService.h"

#import "User.h"
#import "Role.h"
#import "Appointment.h"
#import "Conversation.h"
#import "Message.h"
#import "Family.h"
#import "Family+Analytics.h"
#import "Practice.h"
#import "AppointmentStatus.h"
#import "Guardian+Analytics.h"
#import "LEOCardDeepLink+Analytics.h"

#import "UIColor+LeoColors.h"
#import "UIImage+Extensions.h"
#import "LEOExpandedCardAppointmentViewController.h"
#import "LEOConversationViewController.h"
#import "LEOSettingsViewController.h"
#import "LEOPHRViewController.h"

#import "LEOCardAppointment.h"
#import "LEOCardDeepLink.h"
#import "LEOTransitioningDelegate.h"

#import "LEOFeedHeaderCell+ConfigureForCell.h"
#import "LEOFeedNavigationHeaderView.h"

#import "UIImageEffects.h"

#import "AppDelegate.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import "Configuration.h"

#import "LEOChangeEventObserver.h"
#import "LEOPusherHelper.h"

#import <UIImage+Resize.h>
#import "UIImageEffects.h"

#import "LEOStyleHelper.h"
#import "LEOValidationsHelper.h"
#import "LEOAppointmentViewController.h"
#import "NSObject+XibAdditions.h"
#import "NSObject+TableViewAccurateEstimatedCellHeight.h"

#import "LEOAlertHelper.h"
#import "LEOMessageService.h"
#import "LEOStatusBarNotification.h"
#import "LEOAnalytic+Extensions.h"

#import <TTTAttributedLabel.h>
#import "LEOFormatting.h"
#import "LEOAttributedLabelDelegate.h"

typedef NS_ENUM(NSUInteger, TableViewSection) {
    TableViewSectionHeader,
    TableViewSectionBody,
    TableViewSectionCount,
};


@interface LEOFeedTVC () <LEOChangeEventDelegate>

// TODO: migrate to new pusher architecture, see below
@property (strong, nonatomic) PTPusherEventBinding *pusherBinding;
@property (strong, nonatomic) LEOChangeEventObserver *practiceObserver;
@property (strong, nonatomic) LEOPracticeService *practiceService;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIView *grayView;

@property (strong, nonatomic) LEOFeedNavigationHeaderView *feedNavigatorHeaderView;
@property (strong, nonatomic) NSString *headerMessage;

@property (nonatomic) BOOL enableButtonsInFeed;

@end


@implementation LEOFeedTVC

static NSString *const kCellIdentifierLEOHeaderCell = @"LEOFeedHeaderCell";
static NSString *const kCellIdentifierLEOFeed = @"LEOFeedCell";
static NSString *const kCellIdentifierRouteCard = @"kCellIdentifierRouteCard";



// TODO: MOVE TO ROUTER
- (void)confirmCallUs {

    NSString *practiceName = @"Flatiron Pediatrics";
    NSString *alertTitle = [NSString stringWithFormat:@"You are about to call \n%@\n%@", practiceName,
                            [LEOValidationsHelper formattedPhoneNumberFromPhoneNumber:kFlatironPediatricsPhoneNumber]];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Call" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [LEOAnalytic tagType:LEOAnalyticTypeIntent
                        name:kAnalyticEventCallUs];

        NSString *phoneCallNum = [NSString stringWithFormat:@"tel://%@",kFlatironPediatricsPhoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneCallNum]];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)loadSettings {

    UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:kStoryboardSettings
                                                                 bundle:nil];

    LEOSettingsViewController *settingsVC = [settingsStoryboard instantiateInitialViewController];

    LEOCachePolicy *policy = [LEOCachePolicy new];
    policy.get = LEOCachePolicyGETCacheOnly;
    settingsVC.familyService = [LEOFamilyService serviceWithCachePolicy:policy];
    settingsVC.userService = [LEOUserService serviceWithCachePolicy:policy];

    [self.navigationController pushViewController:settingsVC animated:YES];
}

// TODO:
- (EKEvent *)createEventWithEventStore:eventStore startDate:startDate {

    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    EKCalendar *calendar = [eventStore defaultCalendarForNewEvents];

    event.startDate = startDate;
    event.endDate = [startDate dateByAddingMinutes:30];
    event.title = @"Appointment with pediatrician";
    event.calendar = calendar;
    event.location = [[LEOPracticeService new] getCurrentPractice].name;

    return event;
}


#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {

    [super viewDidLoad];

    self.view.tintColor = [UIColor leo_white];
    self.view.backgroundColor = [UIColor leo_orangeRed];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self setupNotifications];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    [self setupNavigationBar];

    if (!self.headerMessage) {
        self.headerMessage = @"Loading...";
    }
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [LEOAnalytic tagType:LEOAnalyticTypeScreen
                    name:kAnalyticScreenFeed];

    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    [self prepareForReachability];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    NSString *channelString = [NSString stringWithFormat:@"%@",[[LEOUserService new] getCurrentUser].objectID];
    [[LEOPusherHelper sharedPusher] removeBinding:self.pusherBinding fromPrivateChannelWithName:channelString];
}

- (void)setupNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:APIEndpointRouteCards
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:kNotificationConversationAddedMessage
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    self.practiceObserver =
    [LEOChangeEventObserver subscribeToChannel:APIEndpointPractice
                                     withEvent:APIChangeEventPracticeMessagingAvailable
                                       handler:self.practiceService
                                      delegate:nil];

}

- (void)notificationReceived:(NSNotification *)notification {

    if ([notification.name isEqualToString:APIEndpointRouteCards] || [notification.name isEqualToString:kNotificationDownloadedImageUpdated]) {
        [self.tableView reloadData];
    }

    if ([notification.name isEqualToString:kNotificationConversationAddedMessage]) {
        [self fetchDataForCard:notification.object completion:nil];
    }

    if ([notification.name isEqualToString:UIApplicationDidBecomeActiveNotification]) {

        //FIXME: This is a bit misleading because given our card architecture, this is going to happen even when becoming active within a card (e.g. messaging). This is misleading because a) it happens anyway, but b) even if we wanted it to happen, it is happening asynchronously with other operations, so it's not guaranteed to finish before we complete say, a `getMessages` request. I don't believe the specific example I am bringing up poses an issue, but if we rely on this data being up-to-date for another request, it certainly would be an issue. Let's revisit -- adding as an issue to Github as well.
        [self fetchData];
    }
}

- (void)removeObservers {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationConversationAddedMessage object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

    [self.practiceObserver unsubscribe];
}

- (void)dealloc {
    // ????: Do we need this anymore, since we don't support iOS 8?
    [self removeObservers];
}

- (void)prepareForReachability {

    [LEOApiReachability startMonitoringForController:self withOfflineBlock:^{

        self.enableButtonsInFeed = NO;

        BOOL shouldEnableSettingsOffline = YES;
        UINavigationItem* item = self.navigationBar.items.firstObject;
        UIButton *settingsButton = item.leftBarButtonItem.customView;
        settingsButton.enabled = shouldEnableSettingsOffline;

        [self.tableView reloadData];

    } withOnlineBlock:^{

        [self pushNewMessageToConversation];
        [[LEOPusherHelper sharedPusher] connectClient];
        self.enableButtonsInFeed = YES;

        //MARK: temp fix for not allowing user to go to settings or phr until family has downloaded as needed for these functions to work
        if (!self.family) {
            [self willEnableNavigationButtons:NO];
        }

        // FIXME: I found that this sometimes gets called twice in a row.. use LEOPromise to only fetch if not currently waiting for a response
        [self fetchData];
        [self.tableView reloadData];
    }];
}

#pragma mark - Navigation Bar

- (void)setupNavigationBar {

    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [LEOStyleHelper styleNavigationBar:self.navigationBar forFeature:FeatureSettings];
    [LEOStyleHelper styleNavigationBarShadowLineForViewController:self feature:FeatureSettings shadow:NO];

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

- (void)willEnableNavigationButtons:(BOOL)enable {

    UINavigationItem *item = self.navigationBar.items.firstObject;

    UIButton *right = item.rightBarButtonItem.customView;
    UIButton *left = item.leftBarButtonItem.customView;
    right.enabled = enable;
    left.enabled = enable;
}


#pragma mark - Button Actions

- (void)phrTouchedUpInside {

    NSArray *patients = [[[LEOFamilyService new] getFamily] patients];
    LEOPHRViewController *phrViewController = [[LEOPHRViewController alloc] initWithPatients:patients];

    // Without this line, the view ends up getting resized to 0 height, and does not appear (for searching: black screen push animated)
    phrViewController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:phrViewController animated:YES];
}

- (void)bookAppointmentTouchedUpInside {

    [LEOAnalytic tagType:LEOAnalyticTypeEvent
                    name:kAnalyticEventScheduleVisit];

    [ActionHandler handleWithAction:[ActionCreators scheduleNewAppointment]];
}

- (void)messageUsTouchedUpInside {

    [LEOAnalytic tagType:LEOAnalyticTypeEvent
                    name:kAnalyticEventMessageUsFromTopOfPage];
    [ActionHandler handleWithAction:[ActionCreators openPracticeConversation]];
}


#pragma mark - Data Fetching

- (LEOPracticeService *)practiceService {
    if (!_practiceService) {
        _practiceService = [LEOPracticeService new];
    }
    return _practiceService;
}

- (void)fetchFeedHeader {

    LEONoticeService *feedMessageService = [LEONoticeService new];

    [feedMessageService getFeedNoticeForDate:[NSDate date] withCompletion:^(NSString *feedMessage, NSError *error) {

        self.headerMessage = feedMessage;

        dispatch_async(dispatch_get_main_queue() , ^{

            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionHeader] withRowAnimation:UITableViewRowAnimationNone];
        });
    }];
}

- (void)pushNewMessageToConversation {

    NSString *channelString = [NSString stringWithFormat:@"%@", [[LEOUserService new] getCurrentUser].objectID];
    NSString *event = @"new_message";

    LEOPusherHelper *pusherHelper = [LEOPusherHelper sharedPusher];

    __weak typeof(self) weakSelf = self;

    [Configuration downloadRemoteEnvironmentVariablesIfNeededWithCompletion:^(BOOL success, NSError *error) {

        [LEOAnalytic tagType:LEOAnalyticTypeScreen
                        name:kAnalyticScreenFeed];

        typeof(self) strongSelf = weakSelf;

        __weak typeof(self) weakNestedSelf = strongSelf;

        if (success) {
            //MARK: This may be constantly getting reset upon return to the feed. Should it be this way? Something to look into.
            strongSelf.pusherBinding = [pusherHelper connectToPusherChannel:channelString
                                                                  withEvent:event
                                                                     sender:strongSelf
                                                             withCompletion:^(NSDictionary *channelData) {

                                                                 typeof(self) strongNestedSelf = weakNestedSelf;

                                                                 // TODO: fetch only the necessary data
                                                                 [strongNestedSelf fetchDataForCard:nil completion:nil];
                                                             }];
        } else {

            // FIXME: show generic error if server is unreachable
            [LEOAlertHelper alertForViewController:strongSelf
                                             error:error
                                       backupTitle:kErrorTitleMessagingDown
                                     backupMessage:kErrorBodyMessagingDown];
        }
    }];
}

- (void)fetchFamilyWithCompletion:(LEOErrorBlock)completionBlock {

    [[LEOFamilyService new] getFamilyWithCompletion:^(Family *family, NSError *error) {

        if (!error) {
            self.family = family;
        }

        completionBlock(error);
    }];
}

- (void)fetchData {

    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view insertSubview:hud belowSubview:self.navigationBar];
    [hud show:YES];

    [self fetchFeedHeader];

    [self fetchFamilyWithCompletion:^(NSError *error) {

        if (error) {
            [self handleNetworkError:error];
        } else {

            //MARK: temp fix for not allowing user to go to settings or phr until family has downloaded as needed for these functions to work
            [self willEnableNavigationButtons:YES];

            LEOCachePolicy *policy = [LEOCachePolicy new];
            policy.get = LEOCachePolicyGETCacheElseGETNetworkThenPUTCache;
            LEOPracticeService *practiceService = [LEOPracticeService serviceWithCachePolicy:policy];
            [practiceService getPracticesWithCompletion:^(NSArray *practices, NSError *error) {

                if (error) {
                    [self handleNetworkError:error];
                } else {

                    [[LEONoticeService new] getConversationNoticesWithCompletion:^(NSArray *notices, NSError *error) {

                        if (error) {
                            [self handleNetworkError:error];
                        } else {

                            [self fetchDataForCard:nil completion:^(NSArray *cards, NSError *error) {

                                if (error) {
                                    [self handleNetworkError:error];
                                } else {
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                }
                            }];
                        }
                    }];
                }
            }];
        }
    }];
}

- (void)handleNetworkError:(NSError *)error {

    [MBProgressHUD hideHUDForView:self.view animated:YES];

    //If the error is that the phone is offline, that is handled by Reachability.
    if (error.code != NSURLErrorNotConnectedToInternet) {
        [LEOAlertHelper alertForViewController:self title:kErrorDefaultTitle message:kErrorDefaultMessage];
    }
}

- (void)showSomethingWentWrong {

    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:@"Oops! Looks like we had a boo boo."
                                        message:@"We're working on a fix. Check back later!"
                                 preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *action =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * _Nonnull action) {
                               [self dismissViewControllerAnimated:YES
                                                        completion:nil];
                           }];

    [alertController addAction:action];

    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

- (void)fetchDataForCard:(id<LEOCardProtocol>)card completion:(void (^)(NSArray *, NSError *))completionBlock {

    __weak typeof(self) weakSelf = self;
    CardService *cardService = [CardService new];
    [cardService getCardsWithCompletion:^(NSArray *cards, NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionBody] withRowAnimation:UITableViewRowAnimationNone];
        completionBlock ? completionBlock(cards, error) : nil;

    }];
}


#pragma mark - Table View

-(void)setGrayView:(UIView *)grayView {

    _grayView = grayView;
    _grayView.backgroundColor = [UIColor leo_gray227];
}

-(void)setTableView:(UITableView *)tableView {

    _tableView = tableView;

    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [_tableView registerNib:[LEOFeedHeaderCell nib]
     forCellReuseIdentifier:kCellIdentifierLEOHeaderCell];

    [_tableView registerNib:[LEOFeedCell nib]
         forCellReuseIdentifier:kCellIdentifierLEOFeed];

    [_tableView registerNib:[CardCell nib]
         forCellReuseIdentifier:kCellIdentifierRouteCard];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return TableViewSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section) {
        case TableViewSectionHeader:
            return 1;

        case TableViewSectionBody: {
            return [[CardService new] getFeedState].cardStates.count;
        }

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

        case TableViewSectionBody: {
            return [self tableView:tableView cellForBodyRowAtIndexPath:indexPath];
        }

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

    CardCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierRouteCard forIndexPath:indexPath];

    cell.userInteractionEnabled = self.enableButtonsInFeed;

    cell.cardState = [[[CardService new] getFeedState] cardStates][indexPath.row];

    return cell;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    switch (section) {
        case TableViewSectionHeader:
            return nil;

        case TableViewSectionBody:
            self.feedNavigatorHeaderView.userInteractionEnabled = self.enableButtonsInFeed;
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

@end

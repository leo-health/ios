//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "LEOApiReachability.h"
#import "LEOCardConversation.h"
#import "LEOCardPushTransitionAnimator.h"
#import "Configuration.h"
#import "Conversation.h"
#import "Family.h"
#import "Guardian.h"
#import "LEOImageCropViewControllerDataSource.h"
#import "LEOMediaService.h"
#import "Message.h"
#import "MessageImage.h"
#import "MessageText.h"
#import "LEOMessagesAvatarImageFactory.h"
#import "LEOMessageService.h"
#import "LEOMessagesViewController.h"
#import "LEONavigationControllerPopAnimator.h"
#import "LEONavigationControllerPushAnimator.h"
#import "NSDate+Extensions.h"
#import "Practice.h"
#import "LEOPusherHelper.h"
#import "SessionUser.h"
#import "Support.h"
#import "LEOTransitioningDelegate.h"
#import "User.h"
#import "LEOUserService.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "UIImage+Extensions.h"
#import <UIImageView+AFNetworking.h>
#import <JSQMessagesViewController/JSQMessagesBubbleImageFactory.h>
#import <Photos/Photos.h>
#import "UIButton+Extensions.h"
#import "LEOStyleHelper.h"
#import "Configuration.h"
#import "LEOAlertHelper.h"
#import "NSUserDefaults+Extensions.h"

@interface LEOMessagesViewController ()

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@property (copy, nonatomic) NSString *senderFamily;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) UIButton *attachButton;
@property (strong, nonatomic) NSMutableDictionary *avatarDictionary;
@property (strong, nonatomic) LEOTransitioningDelegate *transitioningDelegate;
@property (nonatomic) NSInteger offset;
@property (nonatomic) NSInteger nextPage;

@property (nonatomic) BOOL viewWillAppearOnce;

@property (strong, nonatomic) UIActivityIndicatorView *sendingIndicator;
@property (strong, nonatomic) LEOImageCropViewControllerDataSource *cropDataSource;
@property (strong, nonatomic) NSMutableArray *notificationObservers;
@property (strong, nonatomic) PTPusherEventBinding *pusherBinding;

@end

@implementation LEOMessagesViewController

NSString *const kCopySendPhoto = @"SEND PHOTO";

#pragma mark - View lifecycle

/**
 *  Override point for customization.
 *
 *  Customize your view.
 *  Look at the properties on `JSQMessagesViewController` and `JSQMessagesCollectionView` to see what is possible.
 *
 *  Customize your layout.
 *  Look at the properties on `JSQMessagesCollectionViewFlowLayout` to see what is possible.
 */
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupEmergencyBar];
    [self setupInputToolbar];
    [self setupCollectionViewFormatting];
    [self setupMessageBubbles];
    [self setupRequiredMessagingProperties];
    [self setupPusher];
    [self constructNotifications];
    [LEOStyleHelper roundCornersForView:self.navigationController.view withCornerRadius:kCornerRadius];
}

- (void)viewWillAppear:(BOOL)animated {

    // JSQ will always scroll to bottom if this is set to YES. We want it to happen in other places, but not here
    self.automaticallyScrollsToMostRecentMessage = NO;
    [super viewWillAppear:animated];
    self.automaticallyScrollsToMostRecentMessage = YES;

    [self setupNavigationBar];

    if (!self.viewWillAppearOnce) {

        // scroll to bottom to avoid flicker on first load
        [self scrollToBottomAnimated:NO];
        self.viewWillAppearOnce = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [LEOApiReachability startMonitoringForController:self withOfflineBlock:^{
        self.pusherBinding = nil;
    } withOnlineBlock:^{
        [self resetPusherAndGetMissedMessages];
    }];
}

- (void)setupNavigationBar {

    [self.navigationController.navigationBar setBackgroundImage:[UIImage leo_imageWithColor:self.card.tintColor] forBarMetrics:UIBarMetricsDefault];

    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;

    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"Icon-BackArrow"];

    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"Icon-BackArrow"];

    self.navigationController.navigationBar.topItem.title = @"";

    UIButton *dismissButton = [self buildDismissButton];
    UIBarButtonItem *dismissBBI = [[UIBarButtonItem alloc] initWithCustomView:dismissButton];
    self.navigationItem.rightBarButtonItem = dismissBBI;

    UILabel *navBarTitleLabel = [[UILabel alloc] init];

    navBarTitleLabel.text = @"Chat";
    navBarTitleLabel.textColor = [UIColor leo_white];
    navBarTitleLabel.font = [UIFont leo_menuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    [navBarTitleLabel sizeToFit];

    self.navigationItem.titleView = navBarTitleLabel;
}

- (UIButton *)buildDismissButton {

    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton addTarget:self
                      action:@selector(dismiss)
            forControlEvents:UIControlEventTouchUpInside];
    [dismissButton setImage:[UIImage imageNamed:@"Icon-Cancel"]
                   forState:UIControlStateNormal];
    [dismissButton sizeToFit];
    dismissButton.tintColor = [UIColor leo_white];

    return dismissButton;
}

-(UIButton *)attachButton {

    if (!_attachButton) {
        _attachButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_attachButton setImage:[UIImage imageNamed:@"Icon-Camera-Chat"] forState:UIControlStateNormal];
        //        [_attachButton addTarget:self action:@selector(attachmentButtonTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
        _attachButton.tintColor = [UIColor leo_white];
    }

    return _attachButton;
}

- (void)setupEmergencyBar {

    UILabel *emergencyBar = [UILabel new];

    emergencyBar.text = @"In case of emergency, dial 911";
    emergencyBar.textAlignment = NSTextAlignmentCenter;
    emergencyBar.font = [UIFont leo_emergency911Label];
    emergencyBar.backgroundColor = [UIColor leo_lightBlue];
    emergencyBar.textColor = [UIColor leo_blue];
    [emergencyBar sizeToFit];

    emergencyBar.translatesAutoresizingMaskIntoConstraints = NO;

    self.topContentAdditionalInset = emergencyBar.frame.size.height;

    [self.view addSubview:emergencyBar];

    NSDictionary *views = NSDictionaryOfVariableBindings(emergencyBar);

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[emergencyBar]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:emergencyBar
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.topLayoutGuide
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]];
}

- (void)constructNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:kNotificationConversationAddedMessage
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)removeObservers {
    
    [self.sendButton removeObserver:self forKeyPath:@"enabled"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationConversationAddedMessage object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];

    for (id observer in self.notificationObservers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
}

- (NSMutableArray *)notificationObservers {

    if (!_notificationObservers) {
        _notificationObservers = [NSMutableArray new];
    }

    return _notificationObservers;
}

- (void)dealloc {

    [self clearPusher];
    [self removeObservers];
}

- (void)clearPusher {

    NSString *channelString = [NSString stringWithFormat:@"%@",[SessionUser currentUser].objectID];
    [[LEOPusherHelper sharedPusher] removeBinding:self.pusherBinding fromPrivateChannelWithName:channelString];
    self.pusherBinding = nil;
}

- (void)setupRequiredMessagingProperties {

    self.senderId = [NSString stringWithFormat:@"%@F",[SessionUser currentUser].familyID];
    self.senderDisplayName = [SessionUser currentUser].fullName;
    self.senderFamily = [SessionUser currentUser].familyID;
}

- (void)setupMessageBubbles {

    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor leo_blue]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor leo_grayForMessageBubbles]];
}

- (void)setupCollectionViewFormatting {

    self.collectionView.loadEarlierMessagesHeaderTextColor = [UIColor leo_blue];

    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;

    self.showLoadEarlierMessagesHeader = YES;
    self.collectionView.collectionViewLayout.messageBubbleFont = [UIFont leo_standardFont];
}

- (void)setupInputToolbar {

    self.inputToolbar.contentView.leftBarButtonItem = self.attachButton;

    [self initializeSendButton];

    self.inputToolbar.contentView.rightBarButtonItem = self.sendButton;
    self.inputToolbar.contentView.backgroundColor = [UIColor leo_blue];
    self.inputToolbar.contentView.textView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.inputToolbar.contentView.textView.placeHolder = @"Type a message...";
    self.inputToolbar.contentView.textView.tintColor = [UIColor leo_blue];
    self.inputToolbar.contentView.textView.placeHolderTextColor = [UIColor leo_grayForPlaceholdersAndLines];
    self.inputToolbar.layer.borderColor = [UIColor whiteColor].CGColor;
    self.inputToolbar.contentView.textView.font = [UIFont leo_standardFont];
}

- (void)initializeSendButton {

    UIButton *sendButton = [UIButton leo_newButtonWithDisabledStyling];
    [sendButton setTitle:@"SEND" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor leo_white] forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont];

    self.sendButton = sendButton;

    [self.sendButton addObserver:self forKeyPath:@"enabled" options:NSKeyValueObservingOptionOld context:nil];
}

- (void)setupPusher {

    NSString *channelString = [NSString stringWithFormat:@"%@",[SessionUser currentUser].objectID];
    NSString *event = @"new_message";

    // Need to use weak self here because the PTPusher object holds on to this binding with a strong reference. Must also remove the binding on dealloc
    __weak typeof(self) weakSelf = self;

    LEOPusherHelper *pusherHelper = [LEOPusherHelper sharedPusher];

    [Configuration downloadRemoteEnvironmentVariablesIfNeededWithCompletion:^(BOOL success, NSError *error) {

        __strong typeof(self) strongSelf = weakSelf;

        if (success) {

            __weak typeof(self) weakNestedSelf = strongSelf;

            if (!strongSelf.pusherBinding) {
                strongSelf.pusherBinding = [pusherHelper connectToPusherChannel:channelString withEvent:event sender:strongSelf withCompletion:^(NSDictionary *channelData) {

                    __strong typeof(self) strongNestedSelf = weakNestedSelf;

                    NSString *messageID = [Message extractObjectIDFromChannelData:channelData];

                    __weak typeof(strongSelf) weakDoubleNestedSelf = strongNestedSelf;

                    [[strongSelf conversation] fetchMessageWithID:messageID completion:^{

                        __strong typeof(strongSelf) strongDoubleNestedSelf = weakDoubleNestedSelf;
                        strongDoubleNestedSelf.offset++;
                    }];
                }];
            }
        } else {
            [LEOAlertHelper alertForViewController:self
                                             error:nil
                                       backupTitle:kErrorTitleMessagingDown
                                     backupMessage:kErrorBodyMessagingDown];
        }
    }];
}

- (NSInteger)indexOfMessage:(Message *)message {
    return [[self conversation].messages indexOfObject:message];
}

- (void)notificationReceived:(NSNotification *)notification {

    if ([notification.name isEqualToString:kNotificationConversationAddedMessage]) {

        Conversation *conversation = (Conversation *)notification.object;
        Message *newMessage = conversation.messages.lastObject;
        [self finishSendingMessage:newMessage];
    }

    if ([notification.name isEqualToString:UIApplicationDidEnterBackgroundNotification] || [notification.name isEqualToString:UIApplicationWillResignActiveNotification]) {
        [self clearPusher];
    }

    if ([notification.name isEqualToString:UIApplicationDidBecomeActiveNotification]) {
        [self resetPusherAndGetMissedMessages];
    }
}

- (void)resetPusherAndGetMissedMessages {

    [self setupPusher];

    self.sendButton.hidden = YES;
    [self.sendingIndicator startAnimating];

    [[LEOMessageService new] getMessagesForConversation:[self conversation] page:nil offset:nil sinceDateTime:[self lastMessageDate] withCompletion:^(NSArray * messages, NSError *error) {

        [self.sendingIndicator stopAnimating];
        self.sendButton.hidden = NO;

        if (!error) {
            [self collectionView:self.collectionView updateWithNewMessages:messages startingAtIndex:[self conversation].messages.count];
        } else {
            [LEOAlertHelper alertForViewController:self error:error backupTitle:kErrorTitleMessagingDown backupMessage:kErrorBodyMessagingDown];
        }
    }];
}

- (NSDate *)lastMessageDate {
    
    Message *message = [self conversation].messages.lastObject;
    return message.createdAt;
}

- (void)finishSendingMessage:(Message *)message {

    if ([self isFamilyMessage:message]) {
        [self finishSendingMessageAnimated:YES];
    } else {
        [self finishReceivingMessageAnimated:YES];
    }
}


#pragma mark - JSQMessagesViewController method overrides


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];

    if (object == self.sendButton && [keyPath isEqualToString:@"enabled"]) {

        // Override JSQ behavior of disabling send button
        BOOL reachable = [LEOApiReachability reachable];
        if (!self.sendButton.enabled && reachable) {
            self.sendButton.enabled = YES;
        } else if (self.sendButton.enabled && !reachable) {
            self.sendButton.enabled = NO;
        }
    }
}

/**
 *  Sending a message. Your implementation of this method should do *at least* the following:
 *
 *  1. Play sound (optional)
 *  2. Add new id<JSQMessageData> object to your data source MARK: Currently not using this protocol-driven id. Will come back to determine if necessary.
 *  3. Call `finishSendingMessage`
 */
- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    
    if (text.length == 0) {
        return;
    }

    Message *message = [MessageText messageWithObjectID:nil text:text sender:[SessionUser guardian] escalatedTo:nil escalatedBy:nil status:nil statusCode:MessageStatusCodeUndefined escalatedAt:nil];

    [self startSendingMessage:message];
}

- (UIActivityIndicatorView *)sendingIndicator {

    if (!_sendingIndicator) {

        _sendingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];

        [self.view addSubview:_sendingIndicator];

        _sendingIndicator.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_sendingIndicator);


        //FIXME: These constraints should not include constants, but for a first pass it works well enough across all three phone sizes.
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_sendingIndicator]-(24)-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:viewsDictionary]];

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_sendingIndicator]-(12)-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:viewsDictionary]];
        [_sendingIndicator hidesWhenStopped];
    }

    return _sendingIndicator;
}

- (void)didPressAccessoryButton:(UIButton *)sender {

    [self presentImagePickerViewController];
}

- (void)presentImagePickerViewController {

    [LEOBreadcrumb crumbWithObject:[NSString stringWithFormat:@"%s choose photo", __PRETTY_FUNCTION__]];

    LEOTransitioningDelegate *strongTransitioningDelegate = [[LEOTransitioningDelegate alloc] initWithTransitionAnimatorType:TransitionAnimatorTypeCardPush];;

    self.transitioningDelegate = strongTransitioningDelegate;

    [self.inputToolbar.contentView.textView resignFirstResponder];

    UIAlertController *mediaController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    [mediaController addAction:[UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {

            [[NSOperationQueue mainQueue] addOperationWithBlock:^{

                [LEOBreadcrumb crumbWithObject:[NSString stringWithFormat:@"%s choose photo", __PRETTY_FUNCTION__]];

                UIImagePickerController *pickerController = [UIImagePickerController new];
                pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                pickerController.delegate = self;
                [pickerController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor leo_white], NSFontAttributeName: [UIFont leo_menuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont]}];

                [[UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor leo_white], NSFontAttributeName : [UIFont leo_buttonLabelsAndTimeStampsFont] } forState:UIControlStateNormal];

                [[UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil] setBackButtonBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

                [pickerController.navigationBar setBackgroundImage:[UIImage leo_imageWithColor:self.card.tintColor] forBarMetrics:UIBarMetricsDefault];
                pickerController.transitioningDelegate = self.transitioningDelegate;
                pickerController.modalPresentationStyle = UIModalPresentationCustom;

                pickerController.delegate = self;

                [self presentViewController:pickerController animated:YES completion:nil];
            }];
        }];
    }] ];

    [mediaController addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {

            [[NSOperationQueue mainQueue] addOperationWithBlock:^{

                [LEOBreadcrumb crumbWithObject:[NSString stringWithFormat:@"%s take photo", __PRETTY_FUNCTION__]];

                UIImagePickerController *pickerController = [UIImagePickerController new];
                pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                pickerController.delegate = self;

                [pickerController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor leo_white], NSFontAttributeName: [UIFont leo_menuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont]}];
                pickerController.transitioningDelegate = self.transitioningDelegate;
                pickerController.modalPresentationStyle = UIModalPresentationCustom;

                pickerController.delegate = self;

                [self presentViewController:pickerController animated:YES completion:nil];
            }];
        }];
    }]];


    [mediaController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [LEOBreadcrumb crumbWithObject:[NSString stringWithFormat:@"%s cancel photo", __PRETTY_FUNCTION__]];
    }]];

    [self presentViewController:mediaController animated:YES completion:nil];
}


#pragma mark - <UINavigationControllerDelegate>

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    [LEOStyleHelper imagePickerController:navigationController willShowViewController:viewController forFeature:FeatureMessaging forImagePickerWithDismissTarget:self action:@selector(imagePreviewControllerDidCancel:)];
}

#pragma mark - <UIImagePickerViewControllerDelegate>

//TO finish picking media, get the original image and build a crop view controller with it, simultaneously dismissing the image picker.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    [LEOBreadcrumb crumbWithFunction:__PRETTY_FUNCTION__];

    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];

    if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum (originalImage, nil, nil, nil);
    }

    LEOImagePreviewViewController *previewVC = [[LEOImagePreviewViewController alloc] initWithImage:originalImage cropMode:RSKImageCropModeCustom];
    previewVC.delegate = self;
    previewVC.zoomable = NO;
    previewVC.feature = FeatureMessaging;
    previewVC.leftToolbarButton.hidden = YES;
    previewVC.rightToolbarButton.titleLabel.text = kCopySendPhoto;
    [picker pushViewController:previewVC animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [LEOBreadcrumb crumbWithFunction:__PRETTY_FUNCTION__];

    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePreviewControllerDidCancel:(LEOImagePreviewViewController *)imagePreviewController {

    [LEOBreadcrumb crumbWithFunction:__PRETTY_FUNCTION__];

    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePreviewControllerDidConfirm:(LEOImagePreviewViewController *)imagePreviewController {

    [LEOBreadcrumb crumbWithFunction:__PRETTY_FUNCTION__];

    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [self sendImageMessage:imagePreviewController.image];
}

- (void)startSendingMessage:(Message *)message {

    [LEOBreadcrumb crumbWithFunction:__PRETTY_FUNCTION__];

    self.sendButton.hidden = YES;

    [self.sendingIndicator startAnimating];

//    TODO: Update this with another sound at some point if desired. Leaving the
//          line commented here so we know where it should go in the code.
//    [JSQSystemSoundPlayer jsq_playMessageSentSound];

    [self sendMessage:message withCompletion:^(NSError *error){

        if (!error) {

            [[self conversation] addMessage:message];
            self.offset++;
            [self finishSendingMessage:message];
        }

        self.inputToolbar.contentView.userInteractionEnabled = YES;
        [self.sendingIndicator stopAnimating];
        self.sendButton.hidden = NO;
    }];
}


- (void)sendImageMessage:(UIImage *)image {

    [LEOBreadcrumb crumbWithFunction:__PRETTY_FUNCTION__];

    JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:image];

    MessageImage *message = [MessageImage messageWithObjectID:nil media:photoItem sender:[SessionUser guardian] escalatedTo:nil escalatedBy:nil status:nil statusCode:MessageStatusCodeUndefined createdAt:[NSDate date] escalatedAt:nil leoMedia:nil];

    self.inputToolbar.contentView.userInteractionEnabled = NO;
    [self startSendingMessage:message];

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - JSQMessages Collection View DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self conversation].messages objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return nil;
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{

    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */

    Message *message = [[self conversation].messages objectAtIndex:indexPath.item];

    if ([self isFamilyMessage:message]) {
        return nil;
    }

    __weak typeof(self) weakSelf = self;
    
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationDownloadedImageUpdated object:message.sender.avatar queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull notification) {

        __strong typeof(self) strongSelf = weakSelf;

        JSQMessagesAvatarImage *avatarImage = [strongSelf createAvatarImageForUser:message.sender];

        NSString *avatarID = message.sender.objectID;

        strongSelf.avatarDictionary[avatarID] = avatarImage;

        NSArray *indexPathsForAvatar = [strongSelf visibleIndexPathsForMessagesAssociatedWithUser:message.sender];

        [strongSelf.collectionView.collectionViewLayout invalidateLayoutWithContext:[JSQMessagesCollectionViewFlowLayoutInvalidationContext context]];
        [strongSelf.collectionView reloadItemsAtIndexPaths:indexPathsForAvatar];
    }];

    [self.notificationObservers addObject:observer];

    JSQMessagesAvatarImage *avatarImage = [self avatarForUser:message.sender];

    return avatarImage;
}

- (NSArray <NSIndexPath *>*)visibleIndexPathsForMessagesAssociatedWithUser:(User *)user {


    NSArray *visibleIndexPaths = [self.collectionView indexPathsForVisibleItems];

    NSMutableArray *indexPathsForAvatar = [NSMutableArray new];

    for (NSIndexPath *indexPath in visibleIndexPaths) {

        Message *currentMessage = [self conversation].messages[indexPath.row];

        if (currentMessage.sender.objectID == user.objectID) {
            [indexPathsForAvatar addObject:indexPath];
        }
    }

    return indexPathsForAvatar;
}

- (NSMutableDictionary *)avatarDictionary {

    if (!_avatarDictionary) {
        _avatarDictionary = [NSMutableDictionary new];
    }

    return _avatarDictionary;
}

- (JSQMessagesAvatarImage *)avatarForUser:(User *)user {

    JSQMessagesAvatarImage *combinedImages = [self.avatarDictionary objectForKey:user.objectID];

    if (combinedImages) {
        return combinedImages;
    }

    JSQMessagesAvatarImage *avatarImage = [self createAvatarImageForUser:user];

    [self.avatarDictionary setObject:avatarImage forKey:user.objectID];

    return avatarImage;
}

- (JSQMessagesAvatarImage *)createAvatarImageForUser:(User *)user {

    UIImage *placeholderImage = [LEOMessagesAvatarImageFactory circularAvatarImage:[UIImage imageNamed:@"Icon-ProviderAvatarPlaceholder"] withDiameter:20.0 borderColor:[UIColor leo_grayForPlaceholdersAndLines] borderWidth:2];
    
    JSQMessagesAvatarImage *combinedImages = [JSQMessagesAvatarImage avatarImageWithPlaceholder:placeholderImage];

    combinedImages.avatarImage = [LEOMessagesAvatarImageFactory circularAvatarImage:user.avatar.image withDiameter:kJSQMessagesCollectionViewAvatarSizeDefault borderColor:[UIColor leo_grayForPlaceholdersAndLines] borderWidth:2];

    return combinedImages;
}

- (Conversation *)conversation {

    return (Conversation *)self.card.associatedCardObject;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{

    Message *message = [[self conversation].messages objectAtIndex:indexPath.item];
    Message *priorMessage;

    if (indexPath.row > 0) {
        priorMessage = [[self conversation].messages objectAtIndex:indexPath.row - 1];
    }

    /**
     *  Check to see if the current cell is on a different day than the prior cell, if so, add the date header.
     */
    if (!([NSDate leo_daysBetweenDate:message.date andDate:priorMessage.date] == 0) || indexPath.row == 0) {


        NSDictionary *attributes = @{NSFontAttributeName : [UIFont leo_buttonLabelsAndTimeStampsFont], NSForegroundColorAttributeName : [UIColor leo_grayForTimeStamps]};

        NSString *basicDateString = [NSString stringWithFormat:@"  %@  ", [NSDate leo_stringifiedDateWithDot:message.createdAt]];
        NSAttributedString *dateString = [[NSAttributedString alloc] initWithString:basicDateString attributes:attributes];

        attributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSStrikethroughColorAttributeName: [UIColor leo_grayForTimeStamps], NSStrikethroughStyleAttributeName : [NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle]};

        NSUInteger dateLength = [dateString length];

        NSUInteger fullLengthOfBreak;

        //TODO: At some point...we should clean this up.
        NSInteger screenHeight = [@([UIScreen mainScreen].bounds.size.height) integerValue];
        switch (screenHeight) {
            case 568:
                fullLengthOfBreak = 44;
                break;

            case 667:
                fullLengthOfBreak = 52;
                break;

            case 736:
                fullLengthOfBreak = 58;
                break;

            default:
                fullLengthOfBreak = 44;
                break;
        }

        NSUInteger lengthOfEachLine = floor((fullLengthOfBreak - dateLength) / 2);

        NSMutableString *stringOfLength = [NSMutableString stringWithCapacity: lengthOfEachLine];

        for (int i=0; i<lengthOfEachLine; i++) {
            [stringOfLength appendFormat: @"%C", [@"x" characterAtIndex:0]];
        }

        NSString *strikeThroughString = [stringOfLength copy];

        NSAttributedString *lineString = [[NSAttributedString alloc] initWithString:strikeThroughString attributes:attributes];

        NSMutableAttributedString *fullString = [[NSMutableAttributedString alloc] init];

        [fullString appendAttributedString:lineString];
        [fullString appendAttributedString:dateString];
        [fullString appendAttributedString:lineString];

        if (indexPath.row == 0) {
            return fullString;
        }


        return fullString;
    }

    return nil;
}

//TODO: Refactor this method
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    Message *message = [[self conversation].messages objectAtIndex:indexPath.item];

    /**
     *  iOS7-style sender name labels
     */

    /**
     *  Don't specify attributes to use the defaults.
     */

    NSMutableAttributedString *concatenatedDisplayNameAndTime = [[NSMutableAttributedString alloc] init];

    if ([self isFamilyMessage:message]) {

        NSString *dateString = [NSString stringWithFormat:@"%@ ∙ ", [NSDate leo_stringifiedTime:message.createdAt]];


        NSDictionary *attributes = @{NSFontAttributeName : [UIFont leo_buttonLabelsAndTimeStampsFont], NSForegroundColorAttributeName : [UIColor leo_grayForTimeStamps]};
        NSAttributedString *timestampAttributedString = [[NSAttributedString alloc] initWithString:dateString attributes:attributes];

        [concatenatedDisplayNameAndTime appendAttributedString:timestampAttributedString];

        attributes = @{NSFontAttributeName : [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont], NSForegroundColorAttributeName : [UIColor leo_blue]};
        NSAttributedString *senderAttributedString = [[NSAttributedString alloc] initWithString:message.sender.firstName attributes:attributes];

        [concatenatedDisplayNameAndTime appendAttributedString:senderAttributedString];

    } else {

        NSDictionary *attributes = @{NSFontAttributeName : [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont], NSForegroundColorAttributeName : [UIColor leo_blue]};
        NSAttributedString *senderAttributedString = [[NSAttributedString alloc] initWithString:message.senderDisplayName attributes:attributes];

        [concatenatedDisplayNameAndTime appendAttributedString:senderAttributedString];

        if ([message.sender isKindOfClass:[Support class]]) {

            Support *support = (Support *)message.sender;
            attributes = @{NSFontAttributeName : [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont], NSForegroundColorAttributeName : [UIColor leo_grayForPlaceholdersAndLines]};
            if (support.jobTitle) {
                NSAttributedString *roleAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",support.jobTitle] attributes:attributes];
                [concatenatedDisplayNameAndTime appendAttributedString:roleAttributedString];
            }
        } else if ([message.sender isKindOfClass:[Provider class]]) {

            Provider *provider = (Provider *)message.sender;
            attributes = @{NSFontAttributeName : [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont], NSForegroundColorAttributeName : [UIColor leo_grayForPlaceholdersAndLines]};
            NSString *credential = [provider.credentials firstObject];
            if (credential) {
                NSAttributedString *credentialAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",credential] attributes:attributes];
                [concatenatedDisplayNameAndTime appendAttributedString:credentialAttributedString];
            }
        }

        NSString *dateString = [NSString stringWithFormat:@" ∙ %@", [NSDate leo_stringifiedTime:message.createdAt]];

        attributes = @{NSFontAttributeName : [UIFont leo_buttonLabelsAndTimeStampsFont], NSForegroundColorAttributeName : [UIColor leo_grayForTimeStamps]};
        NSAttributedString *timestampAttributedString = [[NSAttributedString alloc] initWithString:dateString attributes:attributes];

        [concatenatedDisplayNameAndTime appendAttributedString:timestampAttributedString];
    }

    return concatenatedDisplayNameAndTime;

    return nil;
}


#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = [[self conversation].messages count];
    return count;
}

//TODO: Refactor this method ideally
- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    cell.delegate = self;

    Message *message = [self conversation].messages[indexPath.item];

    if ([self isFamilyMessage:message]) {
        cell.textView.backgroundColor = [UIColor leo_blue];
    } else {
        cell.textView.backgroundColor = [UIColor leo_grayForMessageBubbles];
    }

    /**
     *  MARK: This is of course a temporary solution for the first 6 - 12 months until we go back and optimize code for graphics performance.
     */
    cell.textView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.textView.layer.borderWidth = 0.6;
    cell.textView.layer.cornerRadius = 10;
    cell.textView.layer.masksToBounds = YES;

    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cell.layer.shouldRasterize = YES;

    /**
     *  MARK: Issue #184 - First pass solution without modifying JSQ code itself to deal with hardcoded values. May not work on all devices. Must test.
     */

    if ([self isFamilyMessage:message]) {
        cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 10.0f);
    }
    else {
        cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0.0f, 40.0f, 0.0f, 0.0f);
    }

    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */

    if ([message isKindOfClass:[MessageText class]]) {

        if ([self isFamilyMessage:message]) {
            cell.textView.textColor = [UIColor whiteColor];
        }
        else {
            cell.textView.textColor = [UIColor blackColor];
        }

        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }

    if ([message isKindOfClass:[MessageImage class]]) {

        MessageImage *messageImage = (MessageImage *)message;

        JSQPhotoMediaItem *photoMediaItem = (JSQPhotoMediaItem *)messageImage.media;

        if (!photoMediaItem.image) {

            [self addMessageNotificationForMessage:messageImage atIndexPath:indexPath];
            photoMediaItem.image = messageImage.s3Image.image;
        }
    }

    return cell;
}

- (BOOL)isFamilyMessage:(Message *)message {
    return [message.senderId isEqualToString:self.senderId];
}

#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */

    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     */

    Message *message = [[self conversation].messages objectAtIndex:indexPath.item];

    if (indexPath.row == 0) {
        return 40.0f;
    }

    Message *priorMessage = [[self conversation].messages objectAtIndex:indexPath.row - 1];

    if (!([NSDate leo_daysBetweenDate:message.date andDate:priorMessage.date] == 0)) {

        return 40.0f;
    }

    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    /**
     *  iOS7-style sender name labels
     */
    Message *currentMessage = [[self conversation].messages objectAtIndex:indexPath.item];

    if (indexPath.item - 1 > 0) {
        Message *previousMessage = [[self conversation].messages objectAtIndex:indexPath.item - 1];
        if ([previousMessage.sender.objectID isEqualToString:currentMessage.sender.objectID]) {
            return 0.0f;
        }
    }

    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    return 0.0f;
}

#pragma mark - JSQMessagesCollectionViewCell Delegate

- (void)messagesCollectionViewCellDidTapMessageBubble:(JSQMessagesCollectionViewCell *)cell {

    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];

    Message *message = [self conversation].messages[indexPath.item];

    if ([message isKindOfClass:[MessageImage class]]) {

        MessageImage *messageImage = (MessageImage *)message;

        if (messageImage.s3Image.isPlaceholder) {

            [self retryImageLoadForMessageImage:messageImage forIndexPath:indexPath];
        } else {

            [self pushImagePreviewControllerWithMedia:messageImage.media];
        }
    }
}

- (void)retryImageLoadForMessageImage:(MessageImage *)messageImage forIndexPath:(NSIndexPath *)indexPath {

    [messageImage.s3Image setNeedsRefresh];
    [messageImage.s3Image refreshIfNeeded];

    messageImage.media = [[JSQPhotoMediaItem alloc] initWithImage:nil];

    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)pushImagePreviewControllerWithMedia:(id<JSQMessageMediaData>)media {

    JSQPhotoMediaItem *photoMediaItem = (JSQPhotoMediaItem *)media;

    UIImage *image = photoMediaItem.image;

    LEOImagePreviewViewController* lightboxVC = [[LEOImagePreviewViewController alloc] initWithNoCropModeWithImage:image];
    lightboxVC.feature = FeatureMessaging;
    lightboxVC.showsBackButton = YES;

    [self.navigationController pushViewController:lightboxVC animated:YES];
}

// unfortunately, these methods are required, even though we don't want to use them
- (void)messagesCollectionViewCellDidTapCell:(JSQMessagesCollectionViewCell *)cell atPosition:(CGPoint)position {

}

- (void)messagesCollectionViewCellDidTapAvatar:(JSQMessagesCollectionViewCell *)cell {

}

- (void)messagesCollectionViewCell:(JSQMessagesCollectionViewCell *)cell didPerformAction:(SEL)action withSender:(id)sender {

}


#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender {

    [LEOBreadcrumb crumbWithFunction:__PRETTY_FUNCTION__];

    [[LEOMessageService new] getMessagesForConversation:[self conversation] page:@(self.nextPage) offset:@(self.offset) sinceDateTime:nil withCompletion:^void(NSArray *messages, NSError *error) {

        if (error) {
            [LEOAlertHelper alertForViewController:self error:error backupTitle:kErrorTitleMessagingDown backupMessage:kErrorBodyMessagingDown];
        }

        [[self conversation] addMessages:messages];

        [self collectionView:collectionView updateWithNewMessages:messages startingAtIndex:0];
    }];
}


- (void)collectionView:(UICollectionView *)collectionView updateWithNewMessages:(NSArray *)messages startingAtIndex:(NSInteger)startIndex {

    /**
     *  Remove the message if there are no more messages to show. Currently, this is suboptimal as it requires the user to press the button an extra time and make an extra API call. But this is a quick and easy first pass option.
     */
    if (messages.count == 0) {
        self.showLoadEarlierMessagesHeader = NO;
        return;
    }

    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];

    /**
     *  Collect the indexpaths into which we will insert the new messages.
     */
    for (NSInteger i = startIndex; i < [messages count] + startIndex; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [indexPaths addObject:indexPath];
    }

    /**
     *  Add the messages to the conversation object itself
     */
    [[self conversation] addMessages:messages];

    [self collectionView:collectionView avoidFlickerInAnimationWhenInsertingIndexPaths:indexPaths];
}

- (void)addMessageNotificationForMessage:(Message *)message atIndexPath:(NSIndexPath *)indexPath {


    if ([message isKindOfClass:[MessageImage class]]) {

        MessageImage *messageImage = (MessageImage *)message;

        //MARK: The following notifications technically have the same implementation but result from different events. For the time-being, I'd prefer we kept them separate to remind us that two different things are happening. However, if we don't eventually see a real difference between these, we may choose to combine their implementations.

        //Notification for downloading an image from the server
        __weak typeof(self) weakSelf = self;
        id observerDownload = [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationDownloadedImageUpdated object:messageImage.s3Image queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull notification) {

            __strong typeof(self) strongSelf = weakSelf;
            JSQPhotoMediaItem *photoMediaItem = (JSQPhotoMediaItem *)messageImage.media;
            photoMediaItem.image = messageImage.s3Image.image;

            dispatch_async(dispatch_get_main_queue(), ^{

                [strongSelf.collectionView.collectionViewLayout invalidateLayout];
                [strongSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            });
        }];

        //Notification for any local image update
        id observerChanged = [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationImageChanged object:messageImage.s3Image queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull notification) {

            __strong typeof(self) strongSelf = weakSelf;
            JSQPhotoMediaItem *photoMediaItem = (JSQPhotoMediaItem *)messageImage.media;
            photoMediaItem.image = messageImage.s3Image.image;

            dispatch_async(dispatch_get_main_queue(), ^{

                [strongSelf.collectionView.collectionViewLayout invalidateLayout];
                [strongSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            });

        }];

        [self.notificationObservers addObjectsFromArray:@[observerDownload, observerChanged]];
    }
}

/**
 *  Using the method as described here to avoid flicker: http://stackoverflow.com/a/26401767/1938725
 */
- (void)collectionView:(UICollectionView *)collectionView avoidFlickerInAnimationWhenInsertingIndexPaths:(NSArray *)indexPaths {

    CGFloat oldOffset = collectionView.contentSize.height - collectionView.contentOffset.y;

    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    [collectionView performBatchUpdates:^{
        [collectionView insertItemsAtIndexPaths:indexPaths];
    } completion:^(BOOL finished) {
        collectionView.contentOffset = CGPointMake(0.0, collectionView.contentSize.height - oldOffset);
        [CATransaction commit];
    }];
}

/**
 *  Convenience method to send a message for this conversation
 *
 *  @param message         the message you wish to send
 *  @param completionBlock a block for activity once the message has posted
 */
- (void)sendMessage:(Message *)message withCompletion:(void (^) (NSError *))completionBlock {

    LEOMessageService *messageService = [[LEOMessageService alloc] init];

    [messageService createMessage:message forConversation:[self conversation] withCompletion:^(Message * message, NSError * error) {

        if (!error) {

            if (completionBlock) {
                completionBlock(nil);
            }
        } else {

            //  TODO: find a better way of notifiying the user of a failure
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Upload Error" message:@"Sorry, but we're having trouble uploading your message" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            if (completionBlock) {
                completionBlock(error);
            }
        }
    }];
}

/**
 *  Return to prior screen by dismissing the LEOMessagesViewController.
 */
- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}


/**
 *  Helper method to provide information on the next page to load if the `Load Earlier Messages` button is tapped.
 *
 *  Note: Page numbers start at 1, which is why the first page to load is page 2.
 *
 *  @return NSInteger the page number of the next page to load if the `Load Earlier Messages` button is tapped.
 */
-(NSInteger)nextPage {
    
    if (!_nextPage) {
        _nextPage = 2;
    } else {
        _nextPage ++;
    }
    
    return _nextPage;
}


- (id<UIViewControllerAnimatedTransitioning>) navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController*)fromVC
                                                  toViewController:(UIViewController*)toVC {

    switch (operation) {

        case UINavigationControllerOperationPush: {

            LEONavigationControllerPushAnimator *animator = [LEONavigationControllerPushAnimator new];
            return animator;
        }

        case UINavigationControllerOperationPop: {

            LEONavigationControllerPopAnimator *animator = [LEONavigationControllerPopAnimator new];
            return animator;
        }

        case UINavigationControllerOperationNone: {
            return nil;
        }
    }
}


@end
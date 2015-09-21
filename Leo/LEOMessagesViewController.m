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

#import "LEOMessagesViewController.h"
#import <JSQMessagesViewController/JSQMessagesBubbleImageFactory.h>
#import "User.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "Conversation.h"
#import "Message.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "Family.h"
#import "NSDate+Extensions.h"
#import "Support.h"
#import "Guardian.h"
#import "Practice.h"
#import "LEOMessagesAvatarImageFactory.h"
#import "Configuration.h"
#import "SessionUser.h"
#import "LEOPusherHelper.h"
#import <UIImageView+AFNetworking.h>
#import "UIImage+Extensions.h"
#import "LEOCardConversation.h"
#import "LEOUserService.h"
#import "LEOMessageService.h"

#if STUBS_FLAG
#import "LEOStubs.h"
#endif

@interface LEOMessagesViewController ()

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@property (copy, nonatomic) NSString *senderFamily;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) NSMutableDictionary *avatarDictionary;

@property (nonatomic) NSInteger offset;
@property (nonatomic) NSInteger nextPage;

@property (strong, nonatomic) UIActivityIndicatorView *sendingIndicator;

@end

@implementation LEOMessagesViewController

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
    
#if STUBS_FLAG
    [self setupStubs];
#endif
    
    [self setupNavigationBar];
    [self setupEmergencyBar];
    [self setupInputToolbar];
    [self setupCollectionViewFormatting];
    [self setupBubbles];
    [self setupRequiredJSQProperties];
    [self setupPusher];
    [self constructNotifications];
}

#if STUBS_FLAG
- (void)setupStubs {
    
    [LEOStubs setupConversationStubWithID:[SessionUser currentUser].familyID];
}
#endif

/**
 *  Setup the navigation bar with its appropriate color, title, and dismissal button
 */
- (void)setupNavigationBar {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:self.card.tintColor]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"Icon-BackArrow"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"Icon-BackArrow"]];
    self.navigationController.navigationBar.topItem.title = @"";
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [dismissButton setImage:[UIImage imageNamed:@"Icon-Cancel"] forState:UIControlStateNormal];
    [dismissButton sizeToFit];
    [dismissButton setTintColor:[UIColor leoWhite]];
    
    UIBarButtonItem *dismissBBI = [[UIBarButtonItem alloc] initWithCustomView:dismissButton];
    self.navigationItem.rightBarButtonItem = dismissBBI;
    
    UILabel *navBarTitleLabel = [[UILabel alloc] init];
    
    navBarTitleLabel.text = self.card.title;
    navBarTitleLabel.textColor = [UIColor leoWhite];
    navBarTitleLabel.font = [UIFont leoMenuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    [navBarTitleLabel sizeToFit];
    
    self.navigationItem.titleView = navBarTitleLabel;
}

- (void)setupEmergencyBar {
    
    UILabel *emergencyBar = [UILabel new];
    
    emergencyBar.text = @"In case of emergency, dial 911";
    emergencyBar.textAlignment = NSTextAlignmentCenter;
    emergencyBar.font = [UIFont leoMenuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    emergencyBar.backgroundColor = [UIColor leoLightBlue];
    emergencyBar.textColor = [UIColor leoBlue];
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

/**
 *  Construct all notifications
 *
 */
- (void)constructNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceived:) name:@"Conversation-AddedMessage" object:nil];
}

/**
 *  senderId, senderDisplayName required by JSQMessagesViewController, and senderFamily required by LEO.
 */
- (void)setupRequiredJSQProperties {
    
    self.senderId = [NSString stringWithFormat:@"%@F",[SessionUser currentUser].familyID];
    self.senderDisplayName = [SessionUser currentUser].fullName;
    self.senderFamily = [SessionUser currentUser].familyID;
}

/**
 *   Use a bubble factory used to create our underlying image bubbles via JSQ.
 */
- (void)setupBubbles {
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor leoBlue]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor leoGrayForMessageBubbles]];
}

/**
 *  Choose avatar sizing, setup messageBubble font, and load earlier messages header
 */
- (void)setupCollectionViewFormatting {
    
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    //self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    
    self.showLoadEarlierMessagesHeader = YES;
    self.collectionView.collectionViewLayout.messageBubbleFont = [UIFont leoStandardFont];
}

/**
 *  Customize input toolbar
 */
- (void)setupInputToolbar {
    
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"SEND" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor leoWhite] forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont leoFieldAndUserLabelsAndSecondaryButtonsFont];
    
    self.sendButton = sendButton;
    
    self.inputToolbar.contentView.rightBarButtonItem = self.sendButton;
    self.inputToolbar.contentView.backgroundColor = [UIColor leoBlue];
    self.inputToolbar.contentView.textView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.inputToolbar.contentView.textView.placeHolder = @"Type a message...";
    self.inputToolbar.contentView.textView.tintColor = [UIColor leoBlue];
    self.inputToolbar.contentView.textView.placeHolderTextColor = [UIColor leoGrayForPlaceholdersAndLines];
    self.inputToolbar.layer.borderColor = [UIColor whiteColor].CGColor;
    self.inputToolbar.contentView.textView.font = [UIFont leoStandardFont];
}

- (void)setupPusher {
    
    NSString *channelString = [NSString stringWithFormat:@"%@%@",@"newMessage",[SessionUser currentUser].email];
    NSString *event = @"new_message";
    
    LEOPusherHelper *pusherHelper = [LEOPusherHelper sharedPusher];
    [pusherHelper connectToPusherChannel:channelString withEvent:event sender:self withCompletion:^(NSDictionary *channelData) {
        
        [[self conversation] addMessageFromJSON:channelData];
        self.offset ++;
    }];
}

- (void)notificationReceived:(NSNotification *)notification {
    
    if ([notification.name isEqualToString: @"Conversation-AddedMessage"]) {
        
        Conversation *conversation = (Conversation *)notification.object;
        Message *newMessage = conversation.messages.lastObject;
        
        if ([self isFamilyMessage:newMessage]) {
            [self finishSendingMessageAnimated:YES];
        } else {
            [self finishReceivingMessageAnimated:YES];
        }
    }
}


#pragma mark - JSQMessagesViewController method overrides

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
    button.hidden = YES;

    [self.sendingIndicator startAnimating];

    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    Message *message = [Message messageWithObjectID:nil text:text sender:[SessionUser currentUser] escalatedTo:nil escalatedBy:nil status:nil statusCode:MessageStatusCodeUndefined escalatedAt:nil];
    
    [self sendMessage:message withCompletion:^{
        [[self conversation] addMessage:message];
        self.offset ++;
        [self finishSendingMessageAnimated:YES];
        [self.sendingIndicator stopAnimating];
        button.hidden = NO;

    }];
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

- (void)didPressAccessoryButton:(UIButton *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Media messages"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Send photo", @"Send location", @"Send video", nil];
    
    [sheet showFromToolbar:self.inputToolbar];
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
    
    JSQMessagesAvatarImage *avatarImage = [self avatarForUser:message.sender withCompletion:^{
        [self.collectionView.collectionViewLayout invalidateLayoutWithContext:[JSQMessagesCollectionViewFlowLayoutInvalidationContext context]];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }];
    
    return avatarImage;
}


-(NSMutableDictionary *)avatarDictionary {
    
    if (!_avatarDictionary) {
        _avatarDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return _avatarDictionary;
}

- (JSQMessagesAvatarImage *)avatarForUser:(User *)user withCompletion:(void (^) (void))completion {
    
    __block JSQMessagesAvatarImage *combinedImages = [self.avatarDictionary objectForKey:user.objectID];
    
    if (combinedImages) {
        return combinedImages;
    }
    
    
    UIImage *placeholderImage = [LEOMessagesAvatarImageFactory circularAvatarImage:[UIImage imageNamed:@"Icon-AvatarBorderless"] withDiameter:20.0 borderColor:[UIColor leoGrayForPlaceholdersAndLines] borderWidth:2];
    
    combinedImages = [JSQMessagesAvatarImage avatarImageWithPlaceholder:placeholderImage];
    
    __block UIImage *avatarImage;
    __block UIImage *avatarHighlightedImage;
    
    LEOUserService *userService = [[LEOUserService alloc] init];
    
    [userService getAvatarForUser:user withCompletion:^(UIImage *image, NSError * error) {
        
        if (!error) {
            avatarImage = [LEOMessagesAvatarImageFactory circularAvatarImage:image withDiameter:kJSQMessagesCollectionViewAvatarSizeDefault borderColor:[UIColor leoGrayForPlaceholdersAndLines] borderWidth:2];
            avatarHighlightedImage = [LEOMessagesAvatarImageFactory circularAvatarHighlightedImage:image withDiameter:kJSQMessagesCollectionViewAvatarSizeDefault borderColor:[UIColor leoGrayForPlaceholdersAndLines] borderWidth:2];
            
            combinedImages.avatarImage = avatarImage;
            combinedImages.avatarHighlightedImage = avatarHighlightedImage;
            
            [self.avatarDictionary setObject:combinedImages forKey:user.objectID];
            
            completion();
        }
    }];
    
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
    if (!([NSDate daysBetweenDate:message.date andDate:priorMessage.date] == 0) || indexPath.row == 0) {
        
        
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont leoButtonLabelsAndTimeStampsFont], NSForegroundColorAttributeName : [UIColor leoGrayForTimeStamps]};
        
        NSString *basicDateString = [NSString stringWithFormat:@"  %@  ", [NSDate stringifiedDateWithDot:message.createdAt]];
        NSAttributedString *dateString = [[NSAttributedString alloc] initWithString:basicDateString attributes:attributes];
        
        attributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSStrikethroughColorAttributeName: [UIColor leoGrayForTimeStamps], NSStrikethroughStyleAttributeName : [NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle]};
        
        NSUInteger dateLength = [dateString length];
        
        NSUInteger fullLengthOfBreak;
        
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

//TODO: Refactor this method ideally
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
        
        NSString *dateString = [NSString stringWithFormat:@"%@ ∙ ", [NSDate stringifiedTime:message.createdAt]];
        
        
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont leoButtonLabelsAndTimeStampsFont], NSForegroundColorAttributeName : [UIColor leoGrayForTimeStamps]};
        NSAttributedString *timestampAttributedString = [[NSAttributedString alloc] initWithString:dateString attributes:attributes];
        
        [concatenatedDisplayNameAndTime appendAttributedString:timestampAttributedString];
        
        attributes = @{NSFontAttributeName : [UIFont leoFieldAndUserLabelsAndSecondaryButtonsFont], NSForegroundColorAttributeName : [UIColor leoBlue]};
        NSAttributedString *senderAttributedString = [[NSAttributedString alloc] initWithString:message.sender.firstName attributes:attributes];
        
        [concatenatedDisplayNameAndTime appendAttributedString:senderAttributedString];
        
    } else {
        
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont leoFieldAndUserLabelsAndSecondaryButtonsFont], NSForegroundColorAttributeName : [UIColor leoBlue]};
        NSAttributedString *senderAttributedString = [[NSAttributedString alloc] initWithString:message.senderDisplayName attributes:attributes];
        
        [concatenatedDisplayNameAndTime appendAttributedString:senderAttributedString];
        
        if ([message.sender isKindOfClass:[Support class]]) {
            
            Support *support = (Support *)message.sender;
            attributes = @{NSFontAttributeName : [UIFont leoFieldAndUserLabelsAndSecondaryButtonsFont], NSForegroundColorAttributeName : [UIColor leoGrayForPlaceholdersAndLines]};
            NSAttributedString *roleAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",support.roleDisplayName] attributes:attributes];
            [concatenatedDisplayNameAndTime appendAttributedString:roleAttributedString];
        } else if ([message.sender isKindOfClass:[Provider class]]) {
            
            Provider *provider = (Provider *)message.sender;
            attributes = @{NSFontAttributeName : [UIFont leoFieldAndUserLabelsAndSecondaryButtonsFont], NSForegroundColorAttributeName : [UIColor leoGrayForPlaceholdersAndLines]};
            NSAttributedString *credentialAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",provider.credentials[0]] attributes:attributes];
            [concatenatedDisplayNameAndTime appendAttributedString:credentialAttributedString];
        }
        
        NSString *dateString = [NSString stringWithFormat:@" ∙ %@", [NSDate stringifiedTime:message.createdAt]];
        
        attributes = @{NSFontAttributeName : [UIFont leoButtonLabelsAndTimeStampsFont], NSForegroundColorAttributeName : [UIColor leoGrayForTimeStamps]};
        NSAttributedString *timestampAttributedString = [[NSAttributedString alloc] initWithString:dateString attributes:attributes];
        
        [concatenatedDisplayNameAndTime appendAttributedString:timestampAttributedString];
    }
    
    return concatenatedDisplayNameAndTime;
    
    return nil;
}


#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self conversation].messages count];
}

//TODO: Refactor this method ideally
- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    Message *message = [self conversation].messages[indexPath.item];
    
    if ([self isFamilyMessage:message]) {
        cell.textView.backgroundColor = [UIColor leoBlue];
    } else {
        cell.textView.backgroundColor = [UIColor leoGrayForMessageBubbles];
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
    
    if (!message.isMediaMessage) {
        
        if ([self isFamilyMessage:message]) {
            cell.textView.textColor = [UIColor whiteColor];
        }
        else {
            cell.textView.textColor = [UIColor blackColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}

- (BOOL)isFamilyMessage:(Message *)message {
    return [message.senderId isEqualToString:self.senderId];
}

#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    if (!([NSDate daysBetweenDate:message.date andDate:priorMessage.date] == 0)) {
        
        return 40.0f;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
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
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    
    LEOMessageService *messageService = [[LEOMessageService alloc] init];
    
    [messageService getMessagesForConversation:[self conversation] page:self.nextPage offset:self.offset withCompletion:^void(NSArray * messages) {
        
        /**
         *  Remove the message if there are no more messages to show. Currently, this is suboptimal as it requires the user to press the button an extra time and make an extra API call. But this is a quick and easy first pass option.
         */
        if ([messages count] == 0) {
            self.showLoadEarlierMessagesHeader = NO;
            return;
        }
        
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        
        /**
         *  Collect the indexpaths into which we will insert the new messages.
         */
        for (NSInteger i = 0; i < [messages count]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [indexPaths addObject:indexPath];
        }
        
        /**
         *  Add the messages to the conversation object itself
         */
        [[self conversation] addMessages:messages];
        
        /**
         *  Using the method as described here to avoid flicker: http://stackoverflow.com/a/26401767/1938725
         */
        CGFloat oldOffset = self.collectionView.contentSize.height - self.collectionView.contentOffset.y;
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        
        [collectionView performBatchUpdates:^{
            [self.collectionView insertItemsAtIndexPaths:indexPaths];
        } completion:^(BOOL finished) {
            self.collectionView.contentOffset = CGPointMake(0.0, self.collectionView.contentSize.height - oldOffset);
            [CATransaction commit];
        }];
    }];
}

/**
 *  Convenience method to send a message for this conversation
 *
 *  @param message         the message you wish to send
 *  @param completionBlock a block for activity once the message has posted
 */
- (void)sendMessage:(Message *)message withCompletion:(void (^) (void))completionBlock {
    
    LEOMessageService *messageService = [[LEOMessageService alloc] init];
    
    [messageService createMessage:message forConversation:[self conversation] withCompletion:^(Message * message, NSError * error) {
        
        if (!error) {
            
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}

/**
 *  Remove ourselves as an observer.
 */
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  Return to prior screen by dismissing the LEOMessagesViewController.
 */
- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
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
@end
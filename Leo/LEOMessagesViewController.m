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
#import "Family.h"
#import "UIFont+LeoFonts.h"
#import "NSDate+Extensions.h"
#import "Support.h"
#import "Guardian.h"
#import "Practice.h"
#import "LEOMessagesAvatarImageFactory.h"
#import "Configuration.h"
#import "SessionUser.h"

@interface LEOMessagesViewController ()

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@property (copy, nonatomic) NSString *senderFamily;
@property (strong, nonatomic) UIButton *sendButton;
@property (nonatomic) NSInteger pageCount;

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
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupInputToolbar];
    [self setupStubs];
    [self setupCollectionViewFormatting];
    [self setupBubbles];
    [self setupRequiredJSQProperties];
    [self setupCustomMenuActions];
    
    [self.collectionView reloadData];
    self.dataManager = [LEODataManager sharedManager];
}

/**
 *  Register custom menu actions for cells.
 */
- (void)setupCustomMenuActions {
    
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(customAction:)];
    [UIMenuController sharedMenuController].menuItems = @[ [[UIMenuItem alloc] initWithTitle:@"Custom Action" action:@selector(customAction:)] ];
}

/**
 *  senderId, senderDisplayName required by JSQMessagesViewController, and senderFamily required by LEO.
 */
- (void)setupRequiredJSQProperties {
    
    self.senderId = [SessionUser currentUser].objectID;
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
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.showLoadEarlierMessagesHeader = YES;
    self.collectionView.collectionViewLayout.messageBubbleFont = [UIFont leoStandardFont];
}


/**
 *  Load up our data
 */
- (void)loadData {
    
    self.dataManager = [LEODataManager sharedManager];
    
    [self.dataManager getMessagesForConversation:[self conversation] withCompletion:^void(NSArray * messages) {
        
        [[self conversation] addMessages:messages];
        [self.collectionView reloadData];
    }];
}

/**
 *  Customize input toolbar
 */
- (void)setupInputToolbar {
    
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"SEND" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor leoWhite] forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor leoGrayForPlaceholdersAndLines] forState:UIControlStateDisabled];
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
    
    /**
     *  Customize your toolbar buttons
     *
     *  self.inputToolbar.contentView.leftBarButtonItem = custom button or nil to remove
     *  self.inputToolbar.contentView.rightBarButtonItem = custom button or nil to remove
     */
    
    /**
     *  Set a maximum height for the input toolbar
     *
     *  self.inputToolbar.maximumHeight = 150;
     */
}


#pragma mark - Testing
/**
 *  Temporary stub included to see data when running code
 *  Placing stub into a variable in case we decide to remove it programatically later.
 */
- (void)setupStubs {
    
    
    __weak id<OHHTTPStubsDescriptor> messagesStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSLog(@"%@/%@/%@",APIEndpointConversations, [self conversation].objectID, APIEndpointMessages);
        BOOL test = [request.URL.host isEqualToString:[Configuration APIEndpoint]] && [request.URL.path isEqualToString:[NSString stringWithFormat:@"/%@/%@/%@/%@",[Configuration APIVersion], APIEndpointConversations, [self conversation].objectID, APIEndpointMessages]];
        return test;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        
        NSString *fixture = fixture = OHPathForFile(@"../Stubs/getMessagesForUser.json", self.class);
        OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        return response;
    }];
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
    self.inputToolbar.contentView.textView.backgroundColor = [UIColor leoGrayForPlaceholdersAndLines];
    self.inputToolbar.contentView.textView.textColor = [UIColor whiteColor];
    
    self.sendButton.enabled = NO;
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    Message *message = [Message messageWithObjectID:nil text:text sender:[SessionUser currentUser] escalatedTo:nil escalatedBy:nil status:nil statusCode:MessageStatusCodeUndefined escalatedAt:nil];
    
    [self sendMessage:message withCompletion:^{
        [[self conversation] addMessage:message];
        [self finishSendingMessageAnimated:YES];
        
        self.inputToolbar.contentView.textView.backgroundColor = [UIColor whiteColor];
        self.inputToolbar.contentView.textView.textColor = [UIColor leoGrayForPlaceholdersAndLines];

    }];
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
    
    return nil;
    
    Message *message = [[self conversation].messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    
    //FIXME:This should be replaced with the actual avatar, but since we don't yet have those...here is a placeholder.
    
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"objectID == %@", message.sender.objectID];
    
    
    //    User *user = [self.dataManager objectWithObjectID:message.sender.objectID objectArray:[self conversation].participants];
    
    
    
    User *user = [[self conversation].participants filteredArrayUsingPredicate:userPredicate][0];
    
    UIImage *userImage = user.avatar;
    
    NSLog(@"User: %@", user);
    
    JSQMessagesAvatarImage *avatarImage = [LEOMessagesAvatarImageFactory avatarImageWithImage:userImage diameter:kJSQMessagesCollectionViewAvatarSizeDefault borderColor:[UIColor leoGrayForPlaceholdersAndLines]borderWidth:3];
    
    return avatarImage;
}


- (Conversation *)conversation {
    
    return (Conversation *)self.card.associatedCardObject;
}

- (User *)userWithSenderID:(NSString *)senderID {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"senderID", senderID];
    return [self.dataManager.users filteredArrayUsingPredicate:predicate][0];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    
    /** MARK: Zachary Drossman
     *  Check to see if the current cell is on a different day than the prior cell, if so, add the date header.
     */
    
    
    Message *message = [[self conversation].messages objectAtIndex:indexPath.item];
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont leoButtonLabelsAndTimeStampsFont], NSForegroundColorAttributeName : [UIColor leoGrayForTimeStamps]};
    
    NSString *basicDateString = [NSString stringWithFormat:@"  %@  ", [NSDate stringifiedDateWithDot:message.createdAt]];
    NSAttributedString *dateString = [[NSAttributedString alloc] initWithString:basicDateString attributes:attributes];
    
    attributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSStrikethroughColorAttributeName: [UIColor leoGrayForTimeStamps], NSStrikethroughStyleAttributeName : [NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle]};
    
    NSUInteger dateLength = [dateString length];
    NSUInteger fullLengthOfBreak = 60;
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
    
    Message *priorMessage = [[self conversation].messages objectAtIndex:indexPath.row - 1];
    
    if (!([NSDate daysBetweenDate:message.date andDate:priorMessage.date] == 0)) {
        
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
    
    if ([message.sender isKindOfClass:[Guardian class]]) {
        
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
}

/** MARK: Zachary Drossman
 *  Here's where we will do our first pass of case escalation and de-escalation as well as case opening and closing IF we want to do
 *  that.
 */
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    
    
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
    
    /** MARK: Zachary Drossman
     *  Modify this to include other "family side" senders.
     */
    
    Message *message = [self conversation].messages[indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        cell.textView.backgroundColor = [UIColor leoBlue];
    } else {
        cell.textView.backgroundColor = [UIColor leoGrayForMessageBubbles];
    }
    
    cell.textView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.textView.layer.borderWidth = 0.6;
    cell.textView.layer.cornerRadius = 10;
    cell.textView.layer.masksToBounds = YES;
    
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cell.layer.shouldRasterize = YES;
    
    
    /**
     *  MARK: Issue #184 - First pass solution without modifying JSQ code itself to deal with hardcoded values. May not work on all devices. Must test.
     */
    BOOL isOutgoingMessage = [message.sender isKindOfClass:[Guardian class]];
    
    if (isOutgoingMessage) {
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
        
        if ([message.senderId isEqualToString:self.senderId]) {
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



#pragma mark - UICollectionView Delegate

#pragma mark - Custom menu items

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        return YES;
    }
    
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        [self customAction:sender];
        return;
    }
    
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)customAction:(id)sender
{
    NSLog(@"Custom action received! Sender: %@", sender);
    
    [[[UIAlertView alloc] initWithTitle:@"Custom Action"
                                message:nil
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil]
     show];
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
    JSQMessage *currentMessage = [[self conversation].messages objectAtIndex:indexPath.item];
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [[self conversation].messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
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


//TODO: Refactor this method ideally
- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    [self.dataManager getMessagesForConversation:[self conversation] withCompletion:^void(NSArray * messages) {
        
        [[self conversation] addMessages:messages];
        
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < [messages count]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [indexPaths addObject:indexPath];
        }
        
        CGFloat oldOffset = self.collectionView.contentSize.height - self.collectionView.contentOffset.y;
        
        [UIView setAnimationsEnabled:NO];
        
        [collectionView performBatchUpdates:^{
            [self.collectionView insertItemsAtIndexPaths:indexPaths];
        } completion:^(BOOL finished) {
            self.collectionView.contentOffset = CGPointMake(0.0, self.collectionView.contentSize.height - oldOffset);
            [UIView setAnimationsEnabled:YES];
        }];
    }];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble at indexPathSection: %ld Row: %ld!", (long)indexPath.section, (long)indexPath.row);
}


- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

- (void)sendMessage:(Message *)message withCompletion:(void (^) (void))completionBlock {
    
    
    [self.dataManager createMessage:message forConversation:[self conversation] withCompletion:^(Message * message, NSError * error) {
        
        if (!error) {
            
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}


@end
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

#import "DemoMessagesViewController.h"
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

@interface DemoMessagesViewController ()

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@property (copy, nonatomic) NSArray *messages;
@property (copy, nonatomic) NSString *senderFamily;

@end

@implementation DemoMessagesViewController

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
    
    self.dataManager = [LEODataManager sharedManager];
    
    self.title = @"JSQMessages";
    
    self.inputToolbar.contentView.rightBarButtonItem.hidden = YES;
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"SEND" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor leoWhite] forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont leoBodyBolderFont];
    
    self.inputToolbar.contentView.rightBarButtonItem = sendButton;
    self.inputToolbar.contentView.backgroundColor = [UIColor leoBlue];
    self.inputToolbar.contentView.textView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.inputToolbar.contentView.textView.placeHolder = @"Type a message...";
    self.inputToolbar.contentView.textView.tintColor = [UIColor leoBlue];
    
    /**
     *  You MUST set your senderId and display name
     */
    self.senderId = self.dataManager.currentUser.objectID;
    self.senderDisplayName = self.dataManager.currentUser.fullName;
    self.senderFamily = self.dataManager.family.objectID;
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor leoBlue]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor leoGrayBackground]];
    
    
    /**
     *  Load up our data
     */
    
    Conversation *conversation = (Conversation *)self.card.associatedCardObject;
    
    __weak id<OHHTTPStubsDescriptor> messagesStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSLog(@"%@/%@/%@",APIEndpointConversations, conversation.objectID, APIEndpointMessages);
        BOOL test = [request.URL.host isEqualToString:APIHost] && [request.URL.path isEqualToString:[NSString stringWithFormat:@"%@/%@/%@/%@",APIVersion, APIEndpointConversations, conversation.objectID, APIEndpointMessages]];
        return test;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        
        NSString *fixture = fixture = OHPathForFile(@"getConversationForUser.json", self.class);
        OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        return response;
    }];
    
    
    [self.dataManager getMessagesForConversation:conversation withCompletion:^void(NSArray * messages) {
        
        self.messages = messages;
        [self.collectionView reloadData];
    }];
    
    /**
     *  You can set custom avatar sizes
     */
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    self.showLoadEarlierMessagesHeader = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage jsq_defaultTypingIndicatorImage]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(receiveMessagePressed:)];
    
    /**
     *  Register custom menu actions for cells.
     */
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(customAction:)];
    [UIMenuController sharedMenuController].menuItems = @[ [[UIMenuItem alloc] initWithTitle:@"Custom Action" action:@selector(customAction:)] ];
    
    
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
    
    self.collectionView.collectionViewLayout.messageBubbleFont = [UIFont leoBodyFont];
    
}


//#pragma mark - Testing
//
//- (void)pushMainViewController
//{
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UINavigationController *nc = [sb instantiateInitialViewController];
//    [self.navigationController pushViewController:nc.topViewController animated:YES];
//}


#pragma mark - Actions

//- (void)receiveMessagePressed:(UIBarButtonItem *)sender
//{
//    /**
//     *  DEMO ONLY
//     *
//     *  The following is simply to simulate received messages for the demo.
//     *  Do not actually do this.
//     */
//
//
//    /**
//     *  Show the typing indicator to be shown
//     */
//    self.showTypingIndicator = !self.showTypingIndicator;
//
//    /**
//     *  Scroll to actually view the indicator
//     */
//    [self scrollToBottomAnimated:YES];
//
//    /**
//     *  Copy last sent message, this will be the new "received" message
//     */
//    JSQMessage *copyMessage = [[self.messages lastObject] copy];
//
//    if (!copyMessage) {
//        copyMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdJobs
//                                          displayName:kJSQDemoAvatarDisplayNameJobs
//                                                 text:@"First received!"];
//    }
//
//    /**
//     *  Allow typing indicator to show
//     */
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        NSMutableArray *userIds;
//        NSMutableArray *userNames;
//
//        for (User *user in self.dataManager.users) {
//            [userIds addObject:user.objectID];
//            [userNames addObject:user.fullName];
//        }
//
//        [userIds removeObject:self.senderId];
//
//        NSString *randomUserId = userIds[arc4random_uniform((int)[userIds count])];
//
//        Message *newMessage = nil;
//        id<JSQMessageMediaData> newMediaData = nil;
//        id newMediaAttachmentCopy = nil;
//
//        if (copyMessage.isMediaMessage) {
//            /**
//             *  Last message was a media message
//             */
//            id<JSQMessageMediaData> copyMediaData = copyMessage.media;
//
//            if ([copyMediaData isKindOfClass:[JSQPhotoMediaItem class]]) {
//                JSQPhotoMediaItem *photoItemCopy = [((JSQPhotoMediaItem *)copyMediaData) copy];
//                photoItemCopy.appliesMediaViewMaskAsOutgoing = NO;
//                newMediaAttachmentCopy = [UIImage imageWithCGImage:photoItemCopy.image.CGImage];
//
//                /**
//                 *  Set image to nil to simulate "downloading" the image
//                 *  and show the placeholder view
//                 */
//                photoItemCopy.image = nil;
//
//                newMediaData = photoItemCopy;
//            }
//            else if ([copyMediaData isKindOfClass:[JSQLocationMediaItem class]]) {
//                JSQLocationMediaItem *locationItemCopy = [((JSQLocationMediaItem *)copyMediaData) copy];
//                locationItemCopy.appliesMediaViewMaskAsOutgoing = NO;
//                newMediaAttachmentCopy = [locationItemCopy.location copy];
//
//                /**
//                 *  Set location to nil to simulate "downloading" the location data
//                 */
//                locationItemCopy.location = nil;
//
//                newMediaData = locationItemCopy;
//            }
//            else if ([copyMediaData isKindOfClass:[JSQVideoMediaItem class]]) {
//                JSQVideoMediaItem *videoItemCopy = [((JSQVideoMediaItem *)copyMediaData) copy];
//                videoItemCopy.appliesMediaViewMaskAsOutgoing = NO;
//                newMediaAttachmentCopy = [videoItemCopy.fileURL copy];
//
//                /**
//                 *  Reset video item to simulate "downloading" the video
//                 */
//                videoItemCopy.fileURL = nil;
//                videoItemCopy.isReadyToPlay = NO;
//
//                newMediaData = videoItemCopy;
//            }
//            else {
//                NSLog(@"%s error: unrecognized media item", __PRETTY_FUNCTION__);
//            }
//
//            newMessage = [JSQMessage messageWithSenderId:randomUserId
//                                             displayName:[self userWithSenderID:randomUserId].fullName
//                                                   media:newMediaData];
//        }
//        else {
//            /**
//             *  Last message was a text message
//             */
//            newMessage = [JSQMessage messageWithSenderId:randomUserId
//                                             displayName:[self userWithSenderID:randomUserId].fullName
//                                                    text:copyMessage.text];
//        }
//
//        /**
//         *  Upon receiving a message, you should:
//         *
//         *  1. Play sound (optional)
//         *  2. Add new id<JSQMessageData> object to your data source
//         *  3. Call `finishReceivingMessage`
//         */
//        [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
//        [self addMessage:newMessage];
//        [self finishReceivingMessageAnimated:YES];
//
//
//        if (newMessage.isMediaMessage) {
//            /**
//             *  Simulate "downloading" media
//             */
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                /**
//                 *  Media is "finished downloading", re-display visible cells
//                 *
//                 *  If media cell is not visible, the next time it is dequeued the view controller will display its new attachment data
//                 *
//                 *  Reload the specific item, or simply call `reloadData`
//                 */
//
//                if ([newMediaData isKindOfClass:[JSQPhotoMediaItem class]]) {
//                    ((JSQPhotoMediaItem *)newMediaData).image = newMediaAttachmentCopy;
//                    [self.collectionView reloadData];
//                }
//                else if ([newMediaData isKindOfClass:[JSQLocationMediaItem class]]) {
//                    [((JSQLocationMediaItem *)newMediaData)setLocation:newMediaAttachmentCopy withCompletionHandler:^{
//                        [self.collectionView reloadData];
//                    }];
//                }
//                else if ([newMediaData isKindOfClass:[JSQVideoMediaItem class]]) {
//                    ((JSQVideoMediaItem *)newMediaData).fileURL = newMediaAttachmentCopy;
//                    ((JSQVideoMediaItem *)newMediaData).isReadyToPlay = YES;
//                    [self.collectionView reloadData];
//                }
//                else {
//                    NSLog(@"%s error: unrecognized media item", __PRETTY_FUNCTION__);
//                }
//
//            });
//        }
//
//    });
//}



#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    Message *message = [Message messageWithObjectID:nil text:text sender:self.dataManager.currentUser escalatedTo:nil escalatedBy:nil status:nil statusID:nil escalatedAt:nil];
    [self addMessage:message];
    
    [self finishSendingMessageAnimated:YES];
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

//- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == actionSheet.cancelButtonIndex) {
//        return;
//    }
//
//    switch (buttonIndex) {
//        case 0:
//            [self.dataManager addPhotoMediaMessage];
//            break;
//
//        case 1:
//        {
//            __weak UICollectionView *weakView = self.collectionView;
//
//            [self.dataManager addLocationMediaMessageCompletion:^{
//                [weakView reloadData];
//            }];
//        }
//            break;
//
//        case 2:
//            [self.demoData addVideoMediaMessage];
//            break;
//    }
//
//    [JSQSystemSoundPlayer jsq_playMessageSentSound];
//
//    [self finishSendingMessageAnimated:YES];
//}



#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.item];
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
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
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
    Message *message = [self.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    
    //FIXME:This should be replaced with the actual avatar, but since we don't yet have those...here is a placeholder.
    JSQMessagesAvatarImage *avatarImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"AvatarEmily"]
                                                                                     diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    return avatarImage;
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
    
    Message *message = [self.messages objectAtIndex:indexPath.item];

    NSDictionary *attributes = @{NSFontAttributeName : [UIFont leoChatTimestampLabelFont], NSForegroundColorAttributeName : [UIColor leoGrayBodyText]};
    
    //NSString *formattedString = [NSString stringWithFormat: @"-------- %@ --------",[NSDate stringifiedDate:message.date]];
    NSAttributedString *dateString = [[NSAttributedString alloc] initWithString:[NSDate stringifiedDate:message.date] attributes:attributes];

    attributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSStrikethroughStyleAttributeName : [NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle]};
    
    NSAttributedString *lineString = [[NSAttributedString alloc] initWithString:@"strikethrough" attributes:attributes];
    
    NSMutableAttributedString *fullString = [[NSMutableAttributedString alloc] init];
    
    [fullString appendAttributedString:lineString];
    [fullString appendAttributedString:dateString];
    [fullString appendAttributedString:lineString];
    
    if (indexPath.row == 0) {
        return fullString;
    }
    
    Message *priorMessage = [self.messages objectAtIndex:indexPath.row - 1];

    if (!([NSDate daysBetweenDate:message.date andDate:priorMessage.date] == 0)) {

        return fullString;
    }
    
    return nil;
}

//TODO: Refactor this method ideally
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    Message *message = [self.messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    
    NSMutableAttributedString *concatenatedDisplayNameAndTime = [[NSMutableAttributedString alloc] init];

    if ([message.sender isKindOfClass:[Guardian class]]) {
        
        NSString *dateString = [NSString stringWithFormat:@"%@ ∙ ", [NSDate stringifiedTime:message.createdAt]];
        
        
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont leoChatTimestampLabelFont], NSForegroundColorAttributeName : [UIColor leoGrayBodyText]};
        NSAttributedString *timestampAttributedString = [[NSAttributedString alloc] initWithString:dateString attributes:attributes];
        
        [concatenatedDisplayNameAndTime appendAttributedString:timestampAttributedString];
        
        attributes = @{NSFontAttributeName : [UIFont leoButtonFont], NSForegroundColorAttributeName : [UIColor leoBlue]};
        NSAttributedString *senderAttributedString = [[NSAttributedString alloc] initWithString:message.sender.firstName attributes:attributes];
        
        [concatenatedDisplayNameAndTime appendAttributedString:senderAttributedString];

    } else {
        
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont leoButtonFont], NSForegroundColorAttributeName : [UIColor leoBlue]};
        NSAttributedString *senderAttributedString = [[NSAttributedString alloc] initWithString:message.senderDisplayName attributes:attributes];
        
        [concatenatedDisplayNameAndTime appendAttributedString:senderAttributedString];
        
        if ([message.sender isKindOfClass:[Support class]]) {
            
            Support *support = (Support *)message.sender;
            attributes = @{NSFontAttributeName : [UIFont leoButtonFont], NSForegroundColorAttributeName : [UIColor leoGrayBodyText]};
            NSAttributedString *roleAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",support.roleDisplayName] attributes:attributes];
            [concatenatedDisplayNameAndTime appendAttributedString:roleAttributedString];
        } else if ([message.sender isKindOfClass:[Provider class]]) {
            
            Provider *provider = (Provider *)message.sender;
            attributes = @{NSFontAttributeName : [UIFont leoButtonFont], NSForegroundColorAttributeName : [UIColor leoGrayBodyText]};
            NSAttributedString *credentialAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",provider.credentials[0]] attributes:attributes];
            [concatenatedDisplayNameAndTime appendAttributedString:credentialAttributedString];
        }
        
        NSString *dateString = [NSString stringWithFormat:@" ∙ %@", [NSDate stringifiedTime:message.createdAt]];
        
        
        attributes = @{NSFontAttributeName : [UIFont leoChatTimestampLabelFont], NSForegroundColorAttributeName : [UIColor leoGrayBodyText]};
        NSAttributedString *timestampAttributedString = [[NSAttributedString alloc] initWithString:dateString attributes:attributes];
        
        [concatenatedDisplayNameAndTime appendAttributedString:timestampAttributedString];
    }
    
    return concatenatedDisplayNameAndTime;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    
    /** MARK: Zachary Drossman
     *  Here's where we will do our first pass of case escalation and de-escalation as well as case opening and closing IF we want to do
     *  that.
     */
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.messages count];
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
    
    Message *message = self.messages[indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        cell.textView.backgroundColor = [UIColor leoBlue];
    } else {
        cell.textView.backgroundColor = [UIColor leoGrayBackground];
    }
    
    cell.textView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.textView.layer.borderWidth = 0.6;
    cell.textView.layer.cornerRadius = 10;
    cell.textView.layer.masksToBounds = YES;
    
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cell.layer.shouldRasterize = YES;
    
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
    
    Message *message = [self.messages objectAtIndex:indexPath.item];
    
    if (indexPath.row == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    Message *priorMessage = [self.messages objectAtIndex:indexPath.row - 1];
    
    if (!([NSDate daysBetweenDate:message.date andDate:priorMessage.date] == 0)) {
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
    
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.messages objectAtIndex:indexPath.item];
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
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
    Conversation *conversation = (Conversation *)self.card.associatedCardObject;

    [self.dataManager getMessagesForConversation:conversation withCompletion:^void(NSArray * messages) {
        
        [self addMessages:messages];
        
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


//FIXME: This method probably doesn't belong in this class.
- (void)addMessage:(Message *)message {
    
    NSMutableArray *mutableMessages = [self.messages mutableCopy];
    
    [mutableMessages addObject:message];
    
    self.messages = [mutableMessages copy];
}


//FIXME: This method probably doesn't belong in this class.
- (void)addMessages:(NSArray *)messages {
    
    NSMutableArray *mutableMessages = [self.messages mutableCopy];
    
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,[messages count])];
    
    [mutableMessages insertObjects:messages atIndexes:indexes];
    
    self.messages = [mutableMessages copy];
}

@end

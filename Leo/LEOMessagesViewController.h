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


// Import all the things
#import "Message.h"
#import "LEODataManager.h"
#import "LEOCardConversation.h"
#import <JSQMessagesViewController/JSQMessages.h>

@interface LEOMessagesViewController : JSQMessagesViewController <UIActionSheetDelegate>

@property (strong, nonatomic) LEOCardConversation *card;
@property (strong, nonatomic) LEODataManager *dataManager;

//- (void)receiveMessagePressed:(UIBarButtonItem *)sender;
//
//- (void)closePressed:(UIBarButtonItem *)sender;

@end

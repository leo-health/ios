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


@class LEOCardConversation;

#import <JSQMessagesViewController/JSQMessages.h>

@interface LEOMessagesViewController : JSQMessagesViewController <UIActionSheetDelegate>

@property (strong, nonatomic) LEOCardConversation *card;

@end

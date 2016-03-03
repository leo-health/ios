//
//  LEOFeedCell+ConfigureForConversationCard.h
//  Leo
//
//  Created by Zachary Drossman on 3/3/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

@class LEOCardConversation;

#import "LEOFeedCell.h"

@interface LEOFeedCell (ConfigureForConversationCard)

- (void)configureSubviewsForConversationCard:(LEOCardConversation *)card;

@end

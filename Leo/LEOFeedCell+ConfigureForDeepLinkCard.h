//
//  LEOFeedCell+ConfigureForDeepLinkCard.h
//  Leo
//
//  Created by Adam Fanslau on 8/4/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOFeedCell.h"

@class LEOCardDeepLink;

@interface LEOFeedCell (ConfigureForDeepLinkCard)

- (void)configureSubviewsForDeepLinkCard:(LEOCardDeepLink *)card;

@end

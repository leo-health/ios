//
//  LEOFeedCell+ConfigureForDeepLinkCard.m
//  Leo
//
//  Created by Adam Fanslau on 8/4/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOFeedCell+ConfigureForDeepLinkCard.h"
#import "LEOCardDeepLink.h"
#import "UIView+Extensions.h"
#import "LEOFormatting.h"

@implementation LEOFeedCell (ConfigureForDeepLinkCard)

- (void)configureSubviewsForDeepLinkCard:(LEOCardDeepLink *)card {

    [self deeplink_configureHeaderViewForCard:card];
}

- (void)deeplink_configureHeaderViewForCard:(LEOCardDeepLink *)card {

    UILabel *headerLabel = [UILabel new];

    [headerLabel leo_pinToSuperView:self.headerView];

    headerLabel.text = card.tintedHeaderText;
    headerLabel.font = [UIFont leo_bold12];
    headerLabel.textColor = card.tintColor;
}


@end

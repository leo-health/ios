//
//  LEOFeedHeaderCell+ConfigureForCell.m
//  Leo
//
//  Created by Zachary Drossman on 2/23/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOFeedHeaderCell+ConfigureForCell.h"

#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"

#import "LEOSession.h"

@implementation LEOFeedHeaderCell (ConfigureForCell)

- (void)configureForCurrentUserWithMessage:(NSString *)message {

    NSString *firstNameOfCurrentUser = [LEOSession user].firstName;

    self.salutationLabel.text = [NSString stringWithFormat:@"Hey %@,", firstNameOfCurrentUser];
    self.messageTextView.text = message;

    [self formatCell];
}

- (void)formatCell {

    self.salutationLabel.font = [UIFont leo_medium19];
    self.salutationLabel.textColor = [UIColor leo_white];

    self.messageTextView.font = [UIFont leo_regular15];
    self.messageTextView.backgroundColor = [UIColor clearColor];
    self.messageTextView.textColor = [UIColor leo_white];
}


@end

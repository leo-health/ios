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

#import "SessionUser.h"

@implementation LEOFeedHeaderCell (ConfigureForCell)

- (void)configureForCurrentUser {

    NSString *firstNameOfCurrentUser = [SessionUser currentUser].firstName;

    self.salutationLabel.text = [NSString stringWithFormat:@"Hey %@,", firstNameOfCurrentUser];
    self.messageTextView.text = @"This is a test message until we have hooked this up to Twitter.";

    [self formatCell];
}

- (void)formatCell {

    self.salutationLabel.font = [UIFont leo_menuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    self.salutationLabel.textColor = [UIColor leo_white];

    self.messageTextView.font = [UIFont leo_feedHeaderMessage];
    self.messageTextView.backgroundColor = [UIColor clearColor];
    self.messageTextView.textColor = [UIColor leo_white];
}

@end

//
//  LEOLoggedOutLoginCell.m
//  Leo
//
//  Created by Adam Fanslau on 1/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOLoggedOutLoginCell.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "UIButton+Extensions.h"

@interface LEOLoggedOutLoginCell()

@property (weak, nonatomic) UIView *loginView;
@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end

@implementation LEOLoggedOutLoginCell

- (LEOLoginViewController *)contentViewController {

    if (!_contentViewController) {
        UIStoryboard *storyboard =
        [UIStoryboard storyboardWithName:kStoryboardLogin bundle:nil];
        _contentViewController =
        [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LEOLoginViewController class])];
        self.loginView = _contentViewController.view;
        [self.contentView addSubview:self.loginView];
    }
    return _contentViewController;
}

- (void)addViewControllerToParentViewController:(UIViewController *)parentViewController {

    [parentViewController addChildViewController:self.contentViewController];
    [self.contentViewController didMoveToParentViewController:parentViewController];
}

- (void)updateConstraints {

    if (!self.alreadyUpdatedConstraints) {

        self.loginView.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *bindings = NSDictionaryOfVariableBindings(_loginView);

        [self.contentView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_loginView]|"
                                                 options:0
                                                 metrics:nil
                                                   views:bindings]];
        [self.contentView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_loginView]|"
                                                 options:0
                                                 metrics:nil
                                                   views:bindings]];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateConstraints];
}


@end

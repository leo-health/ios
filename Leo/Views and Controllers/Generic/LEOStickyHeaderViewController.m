//
//  LEOStickyHeaderViewController.m
//  Leo
//
//  Created by Zachary Drossman on 11/23/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOStickyHeaderViewController.h"
#import "UIColor+LeoColors.h"
#import "LEOStyleHelper.h"
#import "LEOStickyHeaderView.h"
@interface LEOStickyHeaderViewController ()

@end

@implementation LEOStickyHeaderViewController

-(LEOStickyHeaderView *)stickyHeaderView {

    if (!_stickyHeaderView) {

        LEOStickyHeaderView *strongView = [LEOStickyHeaderView new];

        _stickyHeaderView = strongView;

        [self.view addSubview:_stickyHeaderView];

        [self layoutStickyHeaderView];
    }

    return _stickyHeaderView;
}

- (void)layoutStickyHeaderView {

    self.stickyHeaderView.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *bindings = NSDictionaryOfVariableBindings(_stickyHeaderView);

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_stickyHeaderView]|" options:0 metrics:nil views:bindings]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_stickyHeaderView]|" options:0 metrics:nil views:bindings]];
}

@end

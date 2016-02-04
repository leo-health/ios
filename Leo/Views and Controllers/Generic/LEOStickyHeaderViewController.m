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

@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end


@implementation LEOStickyHeaderViewController

@synthesize feature = _feature;

-(instancetype)initWithFeature:(Feature)feature {

    self = [super init];
    if (self) {

        _feature = feature;
    }
    return self;
}

-(void)viewDidLoad {

    [super viewDidLoad];
}

-(LEOStickyHeaderView *)stickyHeaderView {

    if (!_stickyHeaderView) {

        LEOStickyHeaderView *strongView = [LEOStickyHeaderView new];

        _stickyHeaderView = strongView;
        _stickyHeaderView.feature = _feature;

        [self.view addSubview:_stickyHeaderView];
    }

    return _stickyHeaderView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Not sure why this solves the problem, but without this, the stickyHeaderView will animate its size from CGRectZero to full size along with the navigation controller push
    [self.stickyHeaderView setNeedsLayout];
    [self.stickyHeaderView layoutIfNeeded];
}

- (void)updateViewConstraints {

    if (!self.alreadyUpdatedConstraints) {

        self.stickyHeaderView.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *bindings = NSDictionaryOfVariableBindings(_stickyHeaderView);

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_stickyHeaderView]|" options:0 metrics:nil views:bindings]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_stickyHeaderView]|" options:0 metrics:nil views:bindings]];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateViewConstraints];
}

- (void)addAnimationToNavBar:(void(^)())animations {

    CGFloat duration = [self.navigationController.transitionCoordinator transitionDuration];

    CATransition *animation = [CATransition animation];
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    
    [self.navigationController.navigationBar.layer addAnimation:animation forKey:nil];

    [UIView animateWithDuration:duration animations:animations];
}

-(BOOL)isCollapsed {
    return self.stickyHeaderView.isCollapsed;
}

-(BOOL)isCollapsible {
    return self.stickyHeaderView.isCollapsible;
}

-(void)setCollapsible:(BOOL)collapsible {
    [self.stickyHeaderView setCollapsible:collapsible];
}

-(CGFloat)transitionPercentageForScrollOffset:(CGPoint)offset {
    return [self.stickyHeaderView transitionPercentageForScrollOffset:offset];
}

-(CGPoint)scrollViewContentOffset {
    return self.stickyHeaderView.scrollView.contentOffset;
}

-(Feature)feature {
    return self.stickyHeaderView.feature;
}

-(void)setFeature:(Feature)feature {
    _feature = feature;
    self.stickyHeaderView.feature = feature;
}


@end

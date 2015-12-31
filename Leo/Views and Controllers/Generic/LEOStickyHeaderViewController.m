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

@synthesize stickyHeaderView = _stickyHeaderView;

-(instancetype)initWithFeature:(Feature)feature collapsable:(BOOL)collapsable collapsedHeight:(CGFloat)collapsedHeight {

    self = [super init];
    if (self) {

        self.feature = feature;
        self.collapsable = collapsable;
        self.stickyHeaderView.snapToHeight = collapsedHeight;
    }
    return self;
}

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

- (void)addAnimationToNavBar:(void(^)())animations {

    CGFloat duration = [self.navigationController.transitionCoordinator transitionDuration];

    CATransition *animation = [CATransition animation];
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    
    [self.navigationController.navigationBar.layer addAnimation:animation forKey:nil];

    [UIView animateWithDuration:duration animations:animations];
}

// NOTE: This feels wrong. I should probably move the scrollview delegate into the controller, not the view

-(BOOL)isCollapsed {
    return self.stickyHeaderView.isCollapsed;
}

-(BOOL)isCollapsable {
    return self.stickyHeaderView.isCollapsable;
}

-(void)setCollapsable:(BOOL)collapsable {
    [self.stickyHeaderView setCollapsable:collapsable];
}

-(CGFloat)transitionPercentageForScrollOffset:(CGPoint)offset {
    return [self.stickyHeaderView transitionPercentageForScrollOffset:offset];
}

-(CGPoint)scrollViewContentOffset {
    return self.stickyHeaderView.scrollViewContentOffset;
}

-(Feature)feature {
    return self.stickyHeaderView.feature;
}

-(void)setFeature:(Feature)feature {
    self.stickyHeaderView.feature = feature;
}


@end

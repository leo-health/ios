//
//  LEOStickyHeaderView.m
//  Leo
//
//  Created by Zachary Drossman on 11/23/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOStickyHeaderView.h"
#import "UIColor+LeoColors.h"
#import "LEOStyleHelper.h"
#import <TPKeyboardAvoidingScrollView.h>
#import "LEOCardSubmissionControl.h"
@interface LEOStickyHeaderView ()

@property (nonatomic) BOOL breakerIsOnScreen;
@property (strong, nonatomic) CAShapeLayer *pathLayer;
@property (nonatomic) CGFloat snapToHeight;
@property (weak, nonatomic) UILabel *expandedTitleLabel;

@property (weak, nonatomic) TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) UIView *titleView;
@property (weak, nonatomic) UIView *bodyView;
@property (weak, nonatomic) UIView *contentView;
@property (weak, nonatomic) LEOCardSubmissionControl *submissionControl;

@end

@implementation LEOStickyHeaderView

@synthesize bodyView = _bodyView;

- (instancetype)initWithBodyView:(UIView *)bodyView {
    
    self = [super init];
    
    if (self) {
        _bodyView = bodyView;
        
        [self setupConstraints];
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    
    [self setupBreaker];
    [self setupSubviews];
    [self setupConstraints];
}

- (UIView *)titleView {

    if (!_titleView) {
        UIView *strongView = [UIView new];
        _titleView = strongView;
        
        [self.contentView addSubview:_titleView];
    }
    
    return _titleView;
}

- (UIView *)contentView {
    
    if (!_contentView) {
        
        UIView *strongContentView = [UIView new];
        _contentView = strongContentView;
        
        
        UIView *strongBodyView = [UIView new];
        _bodyView = strongBodyView;
        
        [self.scrollView addSubview:_contentView];
        [_contentView addSubview:_bodyView];
    }
    
    return _contentView;
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        
        TPKeyboardAvoidingScrollView *strongView = [TPKeyboardAvoidingScrollView new];
        _scrollView = strongView;
        
        [self addSubview:_scrollView];
        
        _scrollView.delegate = self;
        _scrollView.bounces = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    
    return _scrollView;
}

-(LEOCardSubmissionControl *)submissionControl {

    if (!_submissionControl) {
        
        LEOCardSubmissionControl *strongButton = [LEOCardSubmissionControl new];
        _submissionControl = strongButton;
        
        [self addSubview:_submissionControl];
    }
    
    return _submissionControl;
}

- (UILabel *)expandedTitleLabel {
    
    if (!_expandedTitleLabel) {
        
        UILabel *strongLabel = [UILabel new];
        _expandedTitleLabel = strongLabel;
        
        [self.titleView addSubview:_expandedTitleLabel];
        
        [LEOStyleHelper styleExpandedTitleLabel:_expandedTitleLabel titleText:@"Test Title"];
    }
    
    return _expandedTitleLabel;
}

- (void)reloadBodyView {
    
    [self.bodyView removeFromSuperview];
    UIView *strongBodyView = [self.datasource injectBodyView];
    _bodyView = strongBodyView;
    [self.contentView addSubview:_bodyView];
    
    [self setupConstraints];
}

-(void)setDatasource:(id<LEOStickyHeaderDataSource>)datasource {
    
    _datasource = datasource;
    
    [self reloadBodyView];
    [self updateButton];
}

- (void)setupSubviews {
    
    self.contentView.backgroundColor = [UIColor blackColor];
    self.titleView.backgroundColor = [UIColor blueColor];
    self.bodyView.backgroundColor = [UIColor redColor];
    self.submissionControl.backgroundColor = [UIColor greenColor];
}

-(void)setMeetsSubmissionRequirements:(BOOL)meetsSubmissionRequirements {

    _meetsSubmissionRequirements = meetsSubmissionRequirements;

    [self.submissionControl isSubmissionReady:meetsSubmissionRequirements];
}

- (void)updateButton {

    [self.submissionControl addTarget:self action:@selector(buttonTouchedUpInside) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonTouchedUpInside {

    [self.delegate submitCardUpdates];
}

//- (void)updateConstraints {
//    
//    if (!self.constraintsAlreadyUpdated) {
//        
//        
//        self.constraintsAlreadyUpdated = YES;
//    
//    }
//    
//}

//FIXME: Remove magic numbers / hard coding.
//TODO: Consider moving autolayout out of a single method into accessor helper methods.
- (void)setupConstraints {
    
    [self removeConstraints:self.constraints];
    [self.scrollView removeConstraints:self.scrollView.constraints];
    [self.contentView removeConstraints:self.contentView.constraints];
    [self.titleView removeConstraints:self.titleView.constraints];
    [self.submissionControl removeConstraints:self.submissionControl.constraints];
    
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bodyView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleView.translatesAutoresizingMaskIntoConstraints = NO;
    self.submissionControl.translatesAutoresizingMaskIntoConstraints = NO;
    self.expandedTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    //TODO: Remove magic number.
    CGFloat titleHeight = 150.0;
    
    //TODO: Need to figure out how to set this via calculation. Based on research so far, the bodyView, which we would like to use to help with the calculation has a frame that is set at 600 x 536, which obviously isn't yet taking into account the constraints on it.
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_titleView, _bodyView, _scrollView, _contentView, _submissionControl, _expandedTitleLabel);
    
    NSArray *verticalLayoutConstraintsForScrollView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView][_submissionControl(==44)]|" options:0 metrics:nil views:viewDictionary];
    NSArray *horizontalLayoutConstraintsForScrollView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:0 metrics:nil views:viewDictionary];
    NSArray *horizontalLayoutConstraintsForButtonView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_submissionControl]|" options:0 metrics:nil views:viewDictionary];
    
    [self addConstraints:verticalLayoutConstraintsForScrollView];
    [self addConstraints:horizontalLayoutConstraintsForScrollView];
    [self addConstraints:horizontalLayoutConstraintsForButtonView];
    
    NSArray *verticalLayoutConstraintsForContentView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|" options:0 metrics:nil views:viewDictionary];
    NSArray *horizontalLayoutConstraintsForContentView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|" options:0 metrics:nil views:viewDictionary];
    [self.scrollView addConstraints:verticalLayoutConstraintsForContentView];
    [self.scrollView addConstraints:horizontalLayoutConstraintsForContentView];
    
    NSArray *verticalLayoutConstraintsForSubviews = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleView(titleHeight)][_bodyView]|" options:0 metrics:@{@"titleHeight" : @(titleHeight)} views:viewDictionary];

    //TODO: This definitely is not the "right" solution. It is the "work" solution. The hardcoding here cannot be removed with this as the solution. Revisit and think through alternative.
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width - 20;
    CGFloat screenWidthWithMargins = screenWidth - 60;
    NSArray *horizontalTitleViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleView(w)]" options:0 metrics:@{@"w" : @(screenWidth)} views:viewDictionary];
    NSArray *horizontalBodyViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(30)-[_bodyView(wM)]-(30)-|" options:0 metrics:@{@"wM" : @(screenWidthWithMargins)} views:viewDictionary];
    
    [self.contentView addConstraints:horizontalBodyViewConstraints];
    [self.contentView addConstraints:horizontalTitleViewConstraints];
    [self.contentView addConstraints:verticalLayoutConstraintsForSubviews];
    
    NSArray *horizontalLayoutConstraintsForFullTitle = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[_expandedTitleLabel]-(100)-|" options:0 metrics:nil views:viewDictionary];
    NSArray *verticalLayoutConstraintsForFullTitle = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_expandedTitleLabel]-(20)-|" options:0 metrics:nil views:viewDictionary];
    
    [self.titleView addConstraints:horizontalLayoutConstraintsForFullTitle];
    [self.titleView addConstraints:verticalLayoutConstraintsForFullTitle];
}

- (void)animateBreakerIfNeeded {
    
    if ([self hasScrolled]) {
        
        self.breakerIsOnScreen ? [self fadeBreakerOut] : [self fadeBreakerIn];
    }
}

- (BOOL)hasScrolled {
    
    return [self scrollViewVerticalContentOffset] > 0;
}

- (void)fadeBreakerOut {
    
    [self updateBreakerWithBlock:^(CABasicAnimation *fadeAnimation) {
        
        [self fadeAnimation:fadeAnimation fromColor:[UIColor leo_orangeRed] toColor:[UIColor clearColor] withStrokeColor:[UIColor clearColor]];
    }];
    
    self.breakerIsOnScreen = NO;
}

- (void)fadeBreakerIn {
    
    [self updateBreakerWithBlock:^(CABasicAnimation *fadeAnimation) {
        
        [self fadeAnimation:fadeAnimation fromColor:[UIColor clearColor] toColor:[UIColor leo_orangeRed] withStrokeColor:[UIColor leo_orangeRed]];
    }];
    
    self.breakerIsOnScreen = YES;
}

- (void)updateBreakerWithBlock:(void (^) (CABasicAnimation *fadeAnimation))transitionBlock {
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"breakerFade"];
    fadeAnimation.duration = 0.3;
    
    transitionBlock(fadeAnimation);
    
    [self.pathLayer addAnimation:fadeAnimation forKey:@"breakerFade"];
}

- (void)fadeAnimation:(CABasicAnimation *)fadeAnimation fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor withStrokeColor:(UIColor *)strokeColor {
    
    fadeAnimation.fromValue = (id)fromColor.CGColor;
    fadeAnimation.toValue = (id)toColor.CGColor;
    
    self.pathLayer.strokeColor = strokeColor.CGColor;
}

- (void)drawBreaker {
    
    CGRect viewRect = CGRectMake(0, 0, self.bounds.size.width, 88);
    
    CGPoint beginningOfLine = CGPointMake(viewRect.origin.x, 0);
    CGPoint endOfLine = CGPointMake(self.bounds.size.width, 0);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:beginningOfLine];
    [path addLineToPoint:endOfLine];
    
    self.pathLayer = [CAShapeLayer layer];
    self.pathLayer.frame = self.bounds;
    self.pathLayer.path = path.CGPath;
    self.pathLayer.strokeColor = [UIColor clearColor].CGColor;
    self.pathLayer.lineWidth = 1.0f;
    self.pathLayer.lineJoin = kCALineJoinBevel;
    
    [self.layer addSublayer:self.pathLayer];
}

- (void)setupBreaker {
    
    [self drawBreaker];
    self.breakerIsOnScreen = NO;
}

#pragma mark - <UIScrollViewDelegate> & Helper Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.scrollView) {
        [self animateBreakerIfNeeded];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (scrollView == self.scrollView) {
        
        decelerate ? nil : [self navigationTitleViewSnapsForScrollView:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == self.scrollView) {
        [self navigationTitleViewSnapsForScrollView:scrollView];
    }
}

- (void)navigationTitleViewSnapsForScrollView:(UIScrollView *)scrollView {
    
    if ([self scrollViewVerticalContentOffset] > [self heightOfNoReturn] & [self scrollViewVerticalContentOffset] < [self heightOfTitleView]) {
        
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [scrollView layoutIfNeeded];
//            self.navigationItem.titleView.alpha = 1;
            scrollView.contentOffset = CGPointMake(0.0, [ self heightOfHeaderCellExcludingOverlapWithNavBar]);
        } completion:nil];
        
        
    } else if ([self scrollViewVerticalContentOffset] < [self heightOfNoReturn]) {
        
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [scrollView layoutIfNeeded];
//            self.navigationItem.titleView.alpha = 0;
            scrollView.contentOffset = CGPointMake(0.0, 0.0);
        } completion:nil];
    }
}

#pragma mark - Layout
-(CGSize)intrinsicContentSize {
    
    // Force the Scroll view to calculate its height
    [self.scrollView layoutIfNeeded];
    
    CGFloat heightWeWouldLikeTheScrollViewContentAreaToBe = [self heightOfScrollViewFrame] + [self heightOfHeaderCellExcludingOverlapWithNavBar];
    
    if ([self totalHeightOfScrollViewContentArea] > [self heightOfScrollViewFrame] && [self totalHeightOfScrollViewContentArea] < heightWeWouldLikeTheScrollViewContentAreaToBe) {
        
        CGFloat bottomInsetWeNeedToGetToHeightWeWouldLikeTheScrollViewContentAreaToBe = heightWeWouldLikeTheScrollViewContentAreaToBe - [self totalHeightOfScrollViewContentArea];
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, bottomInsetWeNeedToGetToHeightWeWouldLikeTheScrollViewContentAreaToBe, 0);
    }
    
    [self.scrollView layoutIfNeeded];
    
    return self.scrollView.contentSize;
}


#pragma mark - Shorthand Helpers

- (CGFloat)heightOfScrollViewFrame {
    return self.scrollView.frame.size.height;
}

- (CGFloat)totalHeightOfScrollViewContentArea {
    return self.scrollView.contentSize.height + self.scrollView.contentInset.bottom;
}

- (CGFloat)heightOfNoReturn {
    return [self heightOfTitleView] * kHeightOfNoReturnConstant;
}

- (CGFloat)heightOfHeaderCellExcludingOverlapWithNavBar {
    
    return [self heightOfTitleView] - [self navBarHeight];
}

- (CGFloat)navBarHeight {
    return self.snapToHeight;
}

- (CGFloat)heightOfTitleView {
    return self.titleView.bounds.size.height;
}

- (UIView *)headerView {
    return self.titleView;
}

- (CGFloat)scrollViewVerticalContentOffset {
    return self.scrollView.contentOffset.y;
}


@end

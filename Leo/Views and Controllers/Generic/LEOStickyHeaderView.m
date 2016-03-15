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
#import "LEOGradientView.h"

#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

@interface LEOStickyHeaderView ()

// TODO: revisit these bools later to try to move toward a more functional architecture with less state
@property (nonatomic) BOOL breakerIsOnScreen;
@property (nonatomic) BOOL snapTransitionInProcess;
@property (nonatomic) BOOL wasExpandedBeforeContentSizeChange;
@property (nonatomic) BOOL forceSnapToStartFromBeginning;
@property (nonatomic) BOOL forceSnapToStartFromEnd;
@property (nonatomic) BOOL scrollingWithTouch;
@property (nonatomic) BOOL keyboardIsVisible;
@property (nonatomic) CGRect keyboardRect;
@property (strong, nonatomic) CAShapeLayer *pathLayer;
@property (weak, nonatomic) UIView *titleView;
@property (strong, nonatomic) NSLayoutConstraint* titleViewTopConstraint;
@property (strong, nonatomic) NSLayoutConstraint* bodyViewTopConstraint;
@property (weak, nonatomic) UIView *bodyView;
@property (weak, nonatomic) UIView *contentView;
@property (weak, nonatomic) UIView *separatorLine;
@property (weak, nonatomic) UIView *footerView;
@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end

@implementation LEOStickyHeaderView

CGFloat const kTitleViewTopConstraintOriginalConstant = 0;
NSString * const kKVOKeyPathContentSize = @"contentSize";
NSString * const kKVOKeyPathContentOffset = @"contentOffset";
NSString * const kAnimationKeyPathStrokeColor = @"strokeColor";

@synthesize bodyView = _bodyView;

#pragma mark  -  Setup and Accessors

- (instancetype)initWithBodyView:(UIView *)bodyView {

    self = [super init];
    if (self) {
        _bodyView = bodyView;
        [self commonInit];
    }
    return self;
}

- (instancetype) init {

    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)dealloc {

    [self removeObservers];
}

- (void)commonInit {

    // default values
    self.collapsible = YES;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.wasExpandedBeforeContentSizeChange = YES; // FIXME: should depend on if the view starts in collapsed position - not yet implemented
    [self registerForKeyboardNotifications];
}

- (UIView *)contentView {

    if (!_contentView) {

        // TODO: refactor - these should be in individual accessor methods. How to deal with side effects correctly?
        UIView *strongContentView = [UIView new];
        _contentView = strongContentView;

        UIView *strongBodyView = [UIView new];
        _bodyView = strongBodyView;

        UIView *strongTitleView = [UIView new];
        _titleView = strongTitleView;

        UIView *strongFooterView = [UIView new];
        _footerView = strongFooterView;

        [self.scrollView addSubview:_contentView];
        [_contentView addSubview:_bodyView];
        [_contentView addSubview:_titleView];
        [self addSubview:_footerView];
    }

    return _contentView;
}

- (TPKeyboardAvoidingScrollView *)scrollView {

    if (!_scrollView) {

        TPKeyboardAvoidingScrollView *strongView = [TPKeyboardAvoidingScrollView new];
        _scrollView = strongView;

        [self addSubview:_scrollView];

        [_scrollView addObserver:self forKeyPath:kKVOKeyPathContentOffset options:NSKeyValueObservingOptionOld context:nil];
        [_scrollView addObserver:self forKeyPath:kKVOKeyPathContentSize options:NSKeyValueObservingOptionOld context:nil];

        _scrollView.delegate = self;
        _scrollView.stickyDelegate = self;

        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;

    }

    return _scrollView;
}

- (UIView *)separatorLine {

    if (!_separatorLine) {

        UIView *strongView = [UIView new];
        _separatorLine = strongView;
        _separatorLine.backgroundColor = [UIColor leo_grayForPlaceholdersAndLines];
        [self addSubview:_separatorLine];
    }

    return _separatorLine;
}

- (void)reloadBodyView {

    [self.bodyView removeFromSuperview];
    UIView *strongBodyView = [self.datasource injectBodyView];
    _bodyView = strongBodyView;

    [self.contentView addSubview:_bodyView];
}

- (void)reloadTitleView {

    if ([self.datasource respondsToSelector:@selector(injectTitleView)]) {
        UIView* strongView = [self.datasource injectTitleView];
        
        if (strongView) {
            
            [self.titleView removeFromSuperview];
            
            _titleView = strongView;
            [_contentView addSubview:_titleView];
        }
    }
}

- (void)reloadFooterView {

    if ([self.datasource respondsToSelector:@selector(injectFooterView)]) {
        UIView* strongFooterView = [self.datasource injectFooterView];

        if (strongFooterView) {

            [self.footerView removeFromSuperview];

            _footerView = strongFooterView;
            [self addSubview:_footerView];
        }
    }
}

- (void)setDatasource:(id<LEOStickyHeaderDataSource>)datasource {

    _datasource = datasource;

    [self reloadBodyView];
    [self reloadTitleView];
    [self reloadFooterView];
}

#pragma mark - Layout

-(void)layoutSubviews {

    [super layoutSubviews];

    if (!self.pathLayer && !self.breakerHidden && self.feature != FeatureUndefined) {
        [self drawBreaker];
    }

    // determine size of titleView
    [self.contentView layoutIfNeeded];

    CGFloat headerHeight = CGRectGetHeight(self.titleView.bounds);

    self.bodyViewTopConstraint.constant = headerHeight;
    // default snapToHeight to be the same height as the header
    if (!self.snapToHeight) {

        self.snapToHeight = @(headerHeight);
    }

    [super layoutSubviews];
}

- (void)updateConstraints {

    if (!self.alreadyUpdatedConstraints) {

        [self removeConstraints:self.constraints];
        [self.scrollView removeConstraints:self.scrollView.constraints];
        [self.contentView removeConstraints:self.contentView.constraints];

        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        self.bodyView.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleView.translatesAutoresizingMaskIntoConstraints = NO;
        self.separatorLine.translatesAutoresizingMaskIntoConstraints = NO;
        self.footerView.translatesAutoresizingMaskIntoConstraints = NO;

        // set Z index so other views will scroll underneath the title view
        if ([self.titleView.superview.subviews indexOfObject:self.titleView] != self.titleView.superview.subviews.count) {
            [self.titleView.superview bringSubviewToFront:self.titleView];
        }

        NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_titleView, _bodyView, _scrollView, _contentView, _separatorLine, _footerView);

        // Outside scroll view
        NSArray *verticalLayoutConstraintsForScrollView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView][_separatorLine(==1)][_footerView]|" options:0 metrics:nil views:viewDictionary];
        NSArray *horizontalLayoutConstraintsForButtonView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_footerView]|" options:0 metrics:nil views:viewDictionary];
        NSArray *horizontalLayoutConstraintsForScrollView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:0 metrics:nil views:viewDictionary];
        NSArray *horizontalLayoutConstraintsForSeparatorLineView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_separatorLine]|" options:0 metrics:nil views:viewDictionary];

        [self addConstraints:verticalLayoutConstraintsForScrollView];
        [self addConstraints:horizontalLayoutConstraintsForScrollView];
        [self addConstraints:horizontalLayoutConstraintsForSeparatorLineView];
        [self addConstraints:horizontalLayoutConstraintsForButtonView];

        // Inside scroll view
        NSArray *verticalLayoutConstraintsForContentView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|" options:0 metrics:nil views:viewDictionary];
        NSArray *horizontalLayoutConstraintsForContentView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|" options:0 metrics:nil views:viewDictionary];
        [self.scrollView addConstraints:verticalLayoutConstraintsForContentView];
        [self.scrollView addConstraints:horizontalLayoutConstraintsForContentView];

        NSArray *horizontalLayoutConstraintsForHeaderView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleView]|" options:0 metrics:nil views:viewDictionary];
        NSArray *horizontalLayoutConstraintsForBodyView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bodyView]|" options:0 metrics:nil views:viewDictionary];

        [self.contentView addConstraints:horizontalLayoutConstraintsForHeaderView];
        [self.contentView addConstraints:horizontalLayoutConstraintsForBodyView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];

        self.titleViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.titleView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:kTitleViewTopConstraintOriginalConstant];
        self.bodyViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.bodyView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:100];

        NSArray *verticalLayoutConstraintsForBodyView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bodyView]|" options:0 metrics:nil views:viewDictionary];

        [self.contentView addConstraint:self.titleViewTopConstraint];
        [self.contentView addConstraint:self.bodyViewTopConstraint];
        [self.contentView addConstraints:verticalLayoutConstraintsForBodyView];
        
        self.alreadyUpdatedConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark - KVO Methods

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    if (object == self.scrollView) {

        if ([keyPath isEqualToString:kKVOKeyPathContentSize]) {

            [self updateScrollInsetsToAllowForCollapse];
        }

        if ([keyPath isEqualToString:kKVOKeyPathContentOffset]) {

            [self snapIfNeededInResponseToObservedContentOffsetChange];
        }
    }
}

- (void)updateScrollInsetsToAllowForCollapse {

    // determine content size via autolayout
    [self.scrollView layoutIfNeeded];

    UIEdgeInsets insets = self.scrollView.contentInset;
    CGFloat insetHeight = insets.bottom; // add top later

    BOOL keyboardIsVisible = self.keyboardIsVisible;
    CGFloat keyboardSize = 0;

    // Since the keyboard is always attached to the bottom of the screen, only add insets for the part that overlaps with the scrollView
    CGFloat maxYDiff = (CGRectGetMaxY(self.keyboardRect) - CGRectGetMaxY(self.scrollView.frame));
    if (keyboardIsVisible) {
        keyboardSize = CGRectGetHeight(self.keyboardRect) - MAX(maxYDiff, 0);
    }

    CGFloat inbetweenSize = [self heightOfHeaderCellExcludingOverlapWithNavBar];
    CGFloat scrollViewSize = CGRectGetHeight(self.scrollView.bounds) - keyboardSize; // available visible space
    CGFloat contentSize = self.scrollView.contentSize.height;
    CGFloat extraHeight = contentSize - scrollViewSize;

    if (extraHeight > 0) {

        insetHeight = inbetweenSize - extraHeight + keyboardSize;
        if (insetHeight < keyboardSize) {
            insetHeight = keyboardSize; // TRUTH: insetHeight >= keyboardSize
        }
    } else {
        insetHeight = keyboardSize;
    }
    insets.bottom = insetHeight;
    self.scrollView.contentInset = insets;


    // other side effects that depend on inset changes

    // scroll view should bounce only if it is scrollable - i.e. contentSize is smaller than frame minus insets
    self.scrollView.bounces = ![self scrollViewContentSizeSmallerThanScrollViewFrameIncludingInsets];
}

- (CGFloat)headerHeight {
    return [self heightOfHeaderCellExcludingOverlapWithNavBar];
}

- (void)snapIfNeededInResponseToObservedContentOffsetChange {

    // header should always be either expanded or collapsed, never in between
    BOOL shouldChangeFromCollapsedToExpanded = !self.wasExpandedBeforeContentSizeChange && [self scrollViewVerticalContentOffset] <= 0;
    BOOL shouldChangeFromExpandedToCollapsed = [self scrollViewVerticalContentOffset] > 0 && ![self isCollapsed]; // self.wasExpandedBeforeContentSizeChange && [self scrollViewVerticalContentOffset];
    BOOL shouldAnimateSnap = shouldChangeFromCollapsedToExpanded || shouldChangeFromExpandedToCollapsed;

    if (!self.scrollingWithTouch && !self.snapTransitionInProcess) {

        if (shouldChangeFromExpandedToCollapsed) {

            [self snapToExpanded:NO animated:shouldAnimateSnap withCompletion:nil];

        } else if (shouldChangeFromCollapsedToExpanded) {

            [self snapToExpanded:YES animated:YES withCompletion:nil];
        }

        if (!self.forceSnapToStartFromBeginning && !self.forceSnapToStartFromEnd) {

            // do nothing in response to the aniation initialization
            [self navigationTitleViewSnapsForScrollView:self.scrollView animated:shouldAnimateSnap];
        }
    }
}

- (void)registerForKeyboardNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stickyHeaderView_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stickyHeaderView_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeObservers {

    [self.scrollView removeObserver:self forKeyPath:kKVOKeyPathContentSize];
    [self.scrollView removeObserver:self forKeyPath:kKVOKeyPathContentOffset];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)stickyHeaderView_keyboardWillShow:(NSNotification *)notification {

    self.keyboardIsVisible = YES;
    self.keyboardRect = [self convertRect:[[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    [self updateScrollInsetsToAllowForCollapse];
}

- (void)stickyHeaderView_keyboardWillHide:(NSNotification *)notification {

    self.keyboardIsVisible = NO;
    self.keyboardRect = [self convertRect:[[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    [self updateScrollInsetsToAllowForCollapse];
}

#pragma mark - <UIScrollViewDelegate> & Helper Methods

-(void)updateTransitionPercentageForScrollOffset:(CGPoint)offset {

    [self animateBreakerIfNeeded];

    // holds position of title view once it reaches the collapsed state
    BOOL shouldStayInCollapsedPosition = offset.y > [self heightOfTitleView] - [self navBarHeight];
    BOOL shouldStayAtTopDuringBounce = self.headerShouldNotBounceOnScroll && offset.y < 0;

    if (shouldStayInCollapsedPosition) {

        // moves title view down while scrolling to keep in the same position
        self.titleViewTopConstraint.constant = offset.y - [self heightOfTitleView] + [self navBarHeight];
    } else if (shouldStayAtTopDuringBounce) {

        // difference between bounce below title view and bounce above title view
        self.titleViewTopConstraint.constant = offset.y;
    } else {

        // ensures that title view stays "attached" to body view during scroll
        self.titleViewTopConstraint.constant = kTitleViewTopConstraintOriginalConstant;
    }

    // prevent redrawing of the gradient if there is no snap in progress and the scroll view is at the bottom
    // this prevents flickering when the user is deleting text from the bottom of the text view
//    if (self.snapTransitionInProcess || ![self scrollViewAtBottomPosition]) {

    // TODO: this check is used to prevent flickering in a scenario which we currently never see in the app. For the time being this fixes the bug where the header doesnt update its transition percentage when the keyboard first appears. We should revisit this when we refactor stickyHeaderView
        // inform the delegate about the transition status
        CGFloat percentage = [self transitionPercentageForScrollOffset:offset];
        percentage = percentage > 1 ? 1 : percentage;

        if ([self.delegate respondsToSelector:@selector(updateTitleViewForScrollTransitionPercentage:)]) {
            [self.delegate updateTitleViewForScrollTransitionPercentage:percentage];
        }
//    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView == self.scrollView) {

        [self updateTransitionPercentageForScrollOffset:self.scrollViewContentOffset];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    if (scrollView == self.scrollView) {

        self.scrollingWithTouch = YES;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    if (scrollView == self.scrollView) {

        BOOL bouncing = scrollView.contentOffset.y < 0;
        if (!bouncing) {

            [self navigationTitleViewSnapsForScrollView:scrollView animated:YES];
        }
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (scrollView == self.scrollView) {

        if (!decelerate) {
            [self navigationTitleViewSnapsForScrollView:scrollView animated:YES];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

    if (scrollView == self.scrollView) {

        [self navigationTitleViewSnapsForScrollView:scrollView animated:YES];
    }
}


-(CGFloat)transitionPercentageForScrollOffset:(CGPoint)offset {
    // handle division by 0
    CGFloat totalHeight = ([self heightOfTitleView] - [self navBarHeight]);
    if (totalHeight == 0) {
        return 0;
    }
    return self.scrollView.contentOffset.y / totalHeight;
}

- (BOOL)scrollViewAtBottomPosition {

    CGFloat maxPossibleOffsetY = self.scrollView.contentSize.height - CGRectGetHeight(self.scrollView.bounds) + self.scrollView.contentInset.bottom + self.scrollView.contentInset.top;
    CGFloat currentOffset = self.scrollView.contentOffset.y;

    // these values are not exact. Compare the rounded values.
    // ????: interestingly, this is the simplest way I've found to compare approximate decimals
    NSString *roundedFormat = @"%.2f";
    NSString *roundedCurrentOffset = [NSString stringWithFormat:roundedFormat, currentOffset];
    NSString *roundedMaxPossibleOffsetY= [NSString stringWithFormat:roundedFormat, maxPossibleOffsetY];

    BOOL atBottom =  [roundedCurrentOffset isEqualToString:roundedMaxPossibleOffsetY];

    return atBottom;
}

#pragma mark  -  Snapping 

- (BOOL)titleViewShouldSnapToExpandedState {

    return ![self isExpanded] && [self scrollViewVerticalContentOffset] < [self heightOfNoReturn];
}

- (BOOL)titleViewShouldSnapToCollapsedState {

    return [self scrollViewVerticalContentOffset] > [self heightOfNoReturn] && [self scrollViewVerticalContentOffset] < [self heightOfHeaderCellExcludingOverlapWithNavBar];
}

- (void)snapToExpanded:(BOOL)expanded {

    if (expanded) {

        self.scrollView.contentOffset = CGPointMake(0.0, 0.0);
    } else {

        self.scrollView.contentOffset = CGPointMake(0.0, [self heightOfHeaderCellExcludingOverlapWithNavBar]);
    }
}

- (BOOL)isCollapsible {

    return [self heightOfHeaderCellExcludingOverlapWithNavBar] > 0;
}

- (void)snapToExpanded:(BOOL)expanded animated:(BOOL)animated withCompletion:(void(^)(BOOL finished))completionBlock {

    void(^_completion)(BOOL finished) = ^void(BOOL finished) {

        [self snapCompletionBlock](finished);
        completionBlock ? completionBlock(finished) : nil;
    };

    self.snapTransitionInProcess = YES;

    if (expanded) {

        self.forceSnapToStartFromEnd = NO;
        self.wasExpandedBeforeContentSizeChange = YES;
    } else {

        self.forceSnapToStartFromBeginning = NO;
        self.wasExpandedBeforeContentSizeChange = NO;
    }

    if (animated) {

        [UIView animateWithDuration:0.5 animations:^{

            [self snapToExpanded:expanded];
        } completion:_completion];

    } else {

        [self snapToExpanded:expanded];
        _completion(YES);
    }
}

- (void(^)(BOOL finished))snapCompletionBlock {

    return ^(BOOL finished) {

        self.snapTransitionInProcess = NO;
        self.scrollingWithTouch = NO;
        [self animateBreakerIfNeeded];
    };
}

-(void)navigationTitleViewSnapsForScrollView:(UIScrollView *)scrollView animated:(BOOL)animated {

    if (self.isCollapsible) {

        // Force collapse
        if (self.forceSnapToStartFromBeginning || [self titleViewShouldSnapToCollapsedState]) {

            [self snapToExpanded:NO animated:animated withCompletion:nil];
        }

        // Force expand
        else if (self.forceSnapToStartFromEnd || [self titleViewShouldSnapToExpandedState]) {

            [self snapToExpanded:YES animated:animated withCompletion:nil];
        }

        else {

            self.wasExpandedBeforeContentSizeChange = [self isExpanded];
            [self snapCompletionBlock](YES);
        }
    }
}

#pragma mark  -  Breaker

- (void)animateBreakerIfNeeded {

    if ([self isCollapsed] && !self.breakerIsOnScreen) {
        [self fadeBreakerIn];
    } else if (![self isCollapsed] && self.breakerIsOnScreen) {
        [self fadeBreakerOut];
    }
}

- (void)fadeBreakerOut {

    [self updateBreakerWithBlock:^(CABasicAnimation *fadeAnimation) {

        [self fadeAnimation:fadeAnimation fromColor:[LEOStyleHelper tintColorForFeature:self.feature] toColor:[UIColor clearColor]];
    }];

    self.breakerIsOnScreen = NO;
}

- (void)fadeBreakerIn {

    [self updateBreakerWithBlock:^(CABasicAnimation *fadeAnimation) {

        [self fadeAnimation:fadeAnimation fromColor:[UIColor clearColor] toColor:[LEOStyleHelper tintColorForFeature:self.feature]];
    }];

    self.breakerIsOnScreen = YES;
}

- (void)updateBreakerWithBlock:(void (^) (CABasicAnimation *fadeAnimation))transitionBlock {

    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:kAnimationKeyPathStrokeColor];
    fadeAnimation.duration = .2;

    transitionBlock(fadeAnimation);

    [self.pathLayer addAnimation:fadeAnimation forKey:kAnimationKeyPathStrokeColor];
}

- (void)fadeAnimation:(CABasicAnimation *)fadeAnimation fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor {

    fadeAnimation.fromValue = (id)fromColor.CGColor;
    fadeAnimation.toValue = (id)toColor.CGColor;
    self.pathLayer.strokeColor = toColor.CGColor;
}

- (void)drawBreaker {

    CGPoint beginningOfLine = CGPointMake(0, [self navBarHeight]);
    CGPoint endOfLine = CGPointMake(CGRectGetMaxX([UIScreen mainScreen].bounds), [self navBarHeight]);

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:beginningOfLine];
    [path addLineToPoint:endOfLine];

    self.pathLayer = [CAShapeLayer layer];
    self.pathLayer.frame = self.bounds;
    self.pathLayer.path = path.CGPath;
    self.pathLayer.strokeColor = [UIColor clearColor].CGColor;
    self.pathLayer.lineWidth = 1.f;
    self.pathLayer.lineJoin = kCALineJoinBevel;
    
    [self.layer addSublayer:self.pathLayer];
}

#pragma mark - Shorthand Helpers

-(BOOL)isCollapsed {
    return [self scrollViewVerticalContentOffset] >= [self heightOfHeaderCellExcludingOverlapWithNavBar];
}

- (BOOL)isExpanded {
    return [self scrollViewVerticalContentOffset] <= 0;
}

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
    return [self.snapToHeight floatValue];
}

- (CGFloat)heightOfTitleView {
    return self.titleView.bounds.size.height;
}

- (UIView *)headerView {
    return self.titleView;
}

- (CGFloat)scrollViewVerticalContentOffset {
    return self.scrollViewContentOffset.y;
}

-(CGPoint)scrollViewContentOffset {
    return self.scrollView.contentOffset;
}

-(BOOL)scrollViewContentSizeSmallerThanScrollViewFrameIncludingInsets {
    return self.scrollView.contentSize.height < (self.scrollView.bounds.size.height - self.scrollView.contentInset.bottom - self.scrollView.contentInset.top);
}

@end

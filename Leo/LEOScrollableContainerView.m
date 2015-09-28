//
//  LEOExpandedNavBarViewController.m
//  Leo
//
//  Created by Zachary Drossman on 8/31/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//


#import "LEOScrollableContainerView.h"
#import "UIImage+Extensions.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "UIScrollView+LEOScrollToVisible.h"

@interface LEOScrollableContainerView()

@property (strong, nonatomic) UILabel *expandedTitleLabel;
@property (strong, nonatomic) UILabel *collapsedTitleLabel;
@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UIView *contentView;
@property (nonatomic) BOOL constraintsAlreadyUpdated;
@property (strong, nonatomic) CALayer *buttonLayer;
@property (nonatomic) NSInteger navBarHeight;
@property (nonatomic) CGFloat scrollFiller;
@end


@implementation LEOScrollableContainerView


#pragma mark - View Controller Lifecycle & Helpers

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self initializeSubviews];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initializeSubviews];
    }
    
    return self;

}

- (void)reloadContainerView {
   
    [self setupScrollView];
    [self accountForNavigationBar];
    [self setupTitleView];
    [self setupCollapsedTitleLabel];
    [self setupBodyView];
    [self updateScrollViewConstraints];
}


- (void)accountForNavigationBar {
    
    self.navBarHeight = 0;
    
    if ([self.delegate accountForNavigationBar]) {
        self.navBarHeight = -98;
    }
}

- (void)initializeSubviews {
    
    self.scrollView = [[UIScrollView alloc] init];
    self.contentView = [[UIView alloc] init];
    self.titleView = [[UIView alloc] init];
    self.expandedTitleLabel = [[UILabel alloc] init];
    self.collapsedTitleLabel = [[UILabel alloc] init];
    
    [self addSubview:self.scrollView];

    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.titleView];
    [self.contentView addSubview:self.bodyView];
    
    [self.titleView addSubview:self.expandedTitleLabel];
    
    [self addSubview:self.collapsedTitleLabel];
}

- (void)setupBodyView {
    self.bodyView = [self.delegate bodyView];
}

- (void)setupScrollView {
    
    self.scrollView.bounces = YES;
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = [self.delegate scrollable];
    self.scrollFiller = 0.0;
    
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    
    if (![self.delegate initialStateExpanded]) {
        self.scrollView.contentOffset = CGPointMake(0, 165);
    }
    
    UITapGestureRecognizer *tapGestureForTextFieldDismissal = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewWasTapped:)];
    tapGestureForTextFieldDismissal.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:tapGestureForTextFieldDismissal];
}

-(void)scrollViewWasTapped:(UIGestureRecognizer*)gesture{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

/**
 *  Setter for the body view
 *
 *  @param bodyView The body of the expandedCardView
 *  @note  Assumes the body view has been set by a subclass of this abstract class. If this class is not subclassed, the lack of bodyView will cause constraints to fail.
 */
-(void)setBodyView:(UIView *)bodyView {
    
    //TODO: This feels bad...let's come back and review at some point.
    [_bodyView removeFromSuperview];
    _bodyView = bodyView;
    [self.contentView addSubview:bodyView];
}

- (void)setupTitleView {

    [self setupExpandedTitleLabel];
    
    if ([self isInExpandedState]) {
        self.expandedTitleLabel.alpha = 1;
        self.collapsedTitleLabel.alpha = 0;
    } else {
        self.expandedTitleLabel.alpha = 0;
        self.collapsedTitleLabel.alpha = 1;
    }
    
    self.titleView.backgroundColor = [UIColor leoWhite]; //TODO: This should be set via a delegate most likely.

}
- (void)setupExpandedTitleLabel {
    
    self.expandedTitleLabel.font = [UIFont leoExpandedCardHeaderFont];
    self.expandedTitleLabel.textColor = [UIColor blackColor];
    self.expandedTitleLabel.numberOfLines = 0;
    self.expandedTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.expandedTitleLabel.text = [self.delegate expandedTitleViewContent];
}

- (void)setupCollapsedTitleLabel {
    
    self.collapsedTitleLabel.font = [UIFont leoMenuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    self.collapsedTitleLabel.textColor = [UIColor blackColor];
    self.collapsedTitleLabel.text = [self.delegate collapsedTitleViewContent];
}

- (BOOL)isInExpandedState {
    
    [self layoutIfNeeded];
    
    CGFloat percentTitleViewHidden = self.scrollView.contentOffset.y / self.titleView.frame.size.height;
    
    if (percentTitleViewHidden < 0.5 || self.titleView.frame.size.height == 0) {
        return YES;
    }
    
    return NO;
}

#pragma mark - <ScrollViewDelegate>
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.scrollView) {
        CGFloat percentTitleViewHidden = scrollView.contentOffset.y / self.titleView.frame.size.height;
        
        if (percentTitleViewHidden < 1) {
            self.expandedTitleLabel.alpha = 1 - percentTitleViewHidden * 2; //FIXME: Magic number
        }
    }
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    if (scrollView == self.scrollView) {
//        [self stoppedScrolling];
//    }
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    
//    if (scrollView == self.scrollView) {
//        
//        if (!decelerate) {
//            [self stoppedScrolling];
//        }
//    }
//}

#pragma mark - Scroll helpers
- (void)stoppedScrolling {
    
    CGFloat percentTitleViewHidden = self.scrollView.contentOffset.y / self.titleView.frame.size.height;
    
    if (percentTitleViewHidden < 1.0) {
        if (percentTitleViewHidden > 0.5) {
            
            [self animateScrollViewTo:self.titleView.frame.size.height withDuration:0.1];
//            [self animateAlphaLevelsOfView:self.expandedTitleLabel to:0 withDuration:0.1];
//            [self animateAlphaLevelsOfView:self.collapsedTitleLabel to:1 withDuration:0.1];
        } else {
            
            [self animateScrollViewTo:self.navBarHeight withDuration:0.1];
//            [self animateAlphaLevelsOfView:self.expandedTitleLabel to:1 withDuration:0.1];
//            [self animateAlphaLevelsOfView:self.collapsedTitleLabel to:0 withDuration:0.1];
        }
    }
}

- (void)animateAlphaLevelsOfView:(UIView *)view to:(NSUInteger)level withDuration:(NSTimeInterval)duration {
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
        view.alpha = level;
    } completion:nil];
}

- (void)animateScrollViewTo:(CGFloat)y withDuration:(NSTimeInterval)duration {
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
        [self.scrollView setContentOffset:CGPointMake(0.0, y) animated:NO];
    } completion:nil];
}

#pragma mark - Constraints


/**
 *  Supports constraining of all views on screen except buttons
 */
- (void)updateScrollViewConstraints {
    
    [self removeConstraints:self.constraints];
    [self.scrollView removeConstraints:self.scrollView.constraints];
    [self.contentView removeConstraints:self.contentView.constraints];
    [self.titleView removeConstraints:self.titleView.constraints];
    
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bodyView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleView.translatesAutoresizingMaskIntoConstraints = NO;
    self.expandedTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.collapsedTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    //TODO: Remove magic number.
    CGFloat titleHeight = 165.0;
    
    //TODO: Need to figure out how to set this via calculation. Based on research so far, the bodyView, which we would like to use to help with the calculation has a frame that is set at 600 x 536, which obviously isn't yet taking into account the constraints on it.
    CGFloat contentViewRemainder = 0; //[self sizeRemainder];
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_titleView, _bodyView, _scrollView, _contentView, _expandedTitleLabel, _collapsedTitleLabel);
    
    NSArray *verticalLayoutConstraintsForScrollView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|" options:0 metrics:nil views:viewDictionary];
    NSArray *horizontalLayoutConstraintsForScrollView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:0 metrics:nil views:viewDictionary];
    
    [self addConstraints:verticalLayoutConstraintsForScrollView];
    [self addConstraints:horizontalLayoutConstraintsForScrollView];
    
    NSArray *verticalLayoutConstraintsForContentView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|" options:0 metrics:nil views:viewDictionary];
    NSArray *horizontalLayoutConstraintsForContentView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|" options:0 metrics:nil views:viewDictionary];
    
//    NSLayoutConstraint *topLayoutConstraintsForContentViewWithView = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
//    
//    
//    NSLayoutConstraint *bottomLayoutConstraintsForContentViewWithView = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
//    
//    [self addConstraint:topLayoutConstraintsForContentViewWithView];
//    [self addConstraint:bottomLayoutConstraintsForContentViewWithView];
    
    [self.scrollView addConstraints:verticalLayoutConstraintsForContentView];
    [self.scrollView addConstraints:horizontalLayoutConstraintsForContentView];

    if (self.scrollView.scrollEnabled) {
        self.scrollFiller = self.window.frame.size.height - self.contentView.frame.size.height + 216.0;
    }
    
   // NSArray *verticalLayoutConstraintsForSubviews = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(navBarHeight)-[_titleView(titleHeight)][_bodyView]-(scrollFiller)-|" options:0 metrics:@{@"titleHeight" : @(titleHeight), @"contentViewRemainder" : @(contentViewRemainder), @"navBarHeight":@(self.navBarHeight), @"scrollFiller":@(self.scrollFiller)} views:viewDictionary];
    
     NSArray *verticalLayoutConstraintsForSubviews = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleView(titleHeight)][_bodyView]-|" options:0 metrics:@{@"titleHeight" : @(titleHeight), @"contentViewRemainder" : @(contentViewRemainder)} views:viewDictionary];
    
    CGFloat screenWidth = self.frame.size.width;
    
    NSArray *horizontalTitleViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleView(w)]" options:0 metrics:@{@"w" : @(screenWidth)} views:viewDictionary];
    NSArray *horizontalBodyViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bodyView(w)]|" options:0 metrics:@{@"w" : @(screenWidth)} views:viewDictionary];
    
    [self.contentView addConstraints:horizontalBodyViewConstraints];
    [self.contentView addConstraints:horizontalTitleViewConstraints];
    [self.contentView addConstraints:verticalLayoutConstraintsForSubviews];
    
    //FIXME: These need to not be hard coded.
    NSArray *horizontalLayoutConstraintsForExpandedTitle = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(29)-[_expandedTitleLabel]-(100)-|" options:0 metrics:nil views:viewDictionary];
    NSArray *verticalLayoutConstraintsForExpandedTitle = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_expandedTitleLabel]-(20)-|" options:0 metrics:nil views:viewDictionary];
    
    [self.titleView addConstraints:horizontalLayoutConstraintsForExpandedTitle];
    [self.titleView addConstraints:verticalLayoutConstraintsForExpandedTitle];
    
    //FIXME: These need to not be hard coded.
    NSArray *horizontalLayoutConstraintsForCollapsedTitle = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collapsedTitleLabel]|" options:0 metrics:nil views:viewDictionary];
    NSArray *verticalLayoutConstraintsForCollapsedTitle = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_collapsedTitleLabel]" options:0 metrics:nil views:viewDictionary];
    
    [self addConstraints:horizontalLayoutConstraintsForCollapsedTitle];
    [self addConstraints:verticalLayoutConstraintsForCollapsedTitle];
    
    [self.contentView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    [self.contentView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
}

@end


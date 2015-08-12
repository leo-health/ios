//
//  LEOExpandedContainerViewController.h.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/3/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOExpandedCardViewController.h"
#import "LEOCard.h"
#import "UIImage+Extensions.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"

@interface LEOExpandedCardViewController ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UIView *buttonView;
@property (strong, nonatomic) UIView *contentView;
@property (nonatomic) BOOL constraintsAlreadyUpdated;
@property (strong, nonatomic) NSDictionary *viewsDictionary;

@end

@implementation LEOExpandedCardViewController


#pragma mark - View Controller Lifecycle & Helpers
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    [self setupNavBar];
    [self setupButtonsAsNeeded]; //MARK: Not sure the "as needed" naming convention will turn out to be appropriate here.
    
    self.scrollView.delegate = self;
    self.titleView.backgroundColor = self.card.tintColor; //TODO: Will ultimately be a gradient of the tintColor with some calculation in a separate image extension class, but for now, this will suffice.
    self.buttonView.backgroundColor = self.card.tintColor;

    self.contentView.backgroundColor = [UIColor whiteColor];
}

-(void)setExpandedFullTitle:(NSString *)expandedFullTitle {
    _expandedFullTitle = expandedFullTitle;
    
    self.titleLabel.text = _expandedFullTitle;
}

- (void)setupSubviews {
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.bounces = NO;
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    
    self.contentView = [[UIView alloc] init];
    
    self.titleView = [[UIView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.buttonView = [[UIView alloc] init];
        
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.buttonView];
    
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView addSubview:self.titleView];
    
    [self.titleView addSubview:self.titleLabel];
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

    [self.view setNeedsUpdateConstraints];
}

- (void)setupNavBar {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:self.card.tintColor]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"Icon-BackArrow"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"Icon-BackArrow"]];
    self.navigationController.navigationBar.topItem.title = @"";
    
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [dismissButton setImage:[UIImage imageNamed:@"Icon-Cancel"] forState:UIControlStateNormal];
    [dismissButton sizeToFit];
    
    UINavigationItem *navCarrier = [[UINavigationItem alloc] init];
    UIBarButtonItem *dismissBBI = [[UIBarButtonItem alloc] initWithCustomView:dismissButton];
    navCarrier.rightBarButtonItems = @[dismissBBI];
    
    self.navigationItem.rightBarButtonItem = dismissBBI;
    
    
    
    UILabel *navBarTitleLabel = [[UILabel alloc] init];
    
    //TODO: Remove this line when done prepping this abstract class and have moved over to complete project.
    navBarTitleLabel.text = self.card.title;
    
    navBarTitleLabel.text = @"Schedule a visit";
    navBarTitleLabel.textColor = [UIColor leoWhite];
    navBarTitleLabel.font = [UIFont leoTitleBoldFont];
    
    [navBarTitleLabel sizeToFit]; //MARK: not sure this is useful anymore now that we have added autolayout.
    
    self.navigationItem.titleView = navBarTitleLabel;
    self.navigationItem.titleView.alpha = 0;
    
    self.titleLabel.text = self.expandedFullTitle;
    self.titleLabel.font = [UIFont leoHeaderLightFont];
    self.titleLabel.textColor = [UIColor leoWhite];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
    CGFloat percentTitleViewHidden = self.scrollView.contentOffset.y / self.titleView.frame.size.height;
    if (percentTitleViewHidden < 0.5) {
            self.navigationItem.titleView.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated  {
    
    [super viewDidAppear:animated];
    
    /**
     *  Oddly, we must use the hidden property of titleView for it to be hidden upon reverting to this view controller after popping one off the stack that is on top of this. See viewWillAppear for the other half of this logic. We set the alpha to 0 in order to ensure that once the view is no longer hidden, it still hides until one pulls down the navBar.
     */
    self.navigationItem.titleView.alpha = 0;
    self.navigationItem.titleView.hidden = NO;

}

#pragma mark - <ScrollViewDelegate>
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.scrollView) {
        CGFloat percentTitleViewHidden = scrollView.contentOffset.y / self.titleView.frame.size.height;
        
        if (percentTitleViewHidden < 1) {
            self.titleLabel.alpha = 1 - percentTitleViewHidden * 2; //FIXME: Magic number
            self.navigationItem.titleView.alpha = percentTitleViewHidden;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        [self stoppedScrolling];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (scrollView == self.scrollView) {
        
        if (!decelerate) {
            [self stoppedScrolling];
        }
    }
}





#pragma mark - Scroll helpers
- (void)stoppedScrolling {
    CGFloat percentTitleViewHidden = self.scrollView.contentOffset.y / self.titleView.frame.size.height;
    
    if (percentTitleViewHidden < 1.0) {
        if (percentTitleViewHidden > 0.5) {
            [self animateScrollViewTo:self.titleView.frame.size.height withDuration:0.1];
        } else {
            [self animateScrollViewTo:0 withDuration:0.1];
        }
    }
}

- (void)animateScrollViewTo:(CGFloat)y withDuration:(NSTimeInterval)duration {
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.scrollView setContentOffset:CGPointMake(0.0, y)];
        
        if (y != 0) {
            self.titleLabel.alpha = 1.0;
            [self.view layoutIfNeeded];
        }
        
    } completion:nil];
}

#pragma mark - Constraints


-(void)updateViewConstraints {
    
    if (!self.constraintsAlreadyUpdated && self.buttonView && self.bodyView) {
        
        [self updateScrollViewConstraints];
        [self updateButtonViewConstraints];
        
        self.constraintsAlreadyUpdated = YES;
    }
    

    
    [super updateViewConstraints];
}


/**
 *  Supports constraining of all views on screen except buttons
 */
- (void)updateScrollViewConstraints {
    
    [self.view removeConstraints:self.view.constraints];
    [self.scrollView removeConstraints:self.scrollView.constraints];
    [self.contentView removeConstraints:self.contentView.constraints];
    [self.titleView removeConstraints:self.titleView.constraints];
    
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.buttonView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bodyView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    //TODO: Remove magic number.
    CGFloat titleHeight = 150.0;
    
    //TODO: Need to figure out how to set this via calculation. Based on research so far, the bodyView, which we would like to use to help with the calculation has a frame that is set at 600 x 536, which obviously isn't yet taking into account the constraints on it.
    CGFloat contentViewRemainder = 200;
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_titleView, _buttonView, _bodyView, _scrollView, _contentView, _titleLabel);
    
    NSArray *verticalLayoutConstraintsForScrollView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView][_buttonView(==44)]|" options:0 metrics:nil views:viewDictionary];
    NSArray *horizontalLayoutConstraintsForScrollView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:0 metrics:nil views:viewDictionary];
    NSArray *horizontalLayoutConstraintsForButtonView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonView]|" options:0 metrics:nil views:viewDictionary];
    
    [self.view addConstraints:verticalLayoutConstraintsForScrollView];
    [self.view addConstraints:horizontalLayoutConstraintsForScrollView];
    [self.view addConstraints:horizontalLayoutConstraintsForButtonView];
    
    NSArray *verticalLayoutConstraintsForContentView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|" options:0 metrics:nil views:viewDictionary];
    NSArray *horizontalLayoutConstraintsForContentView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|" options:0 metrics:nil views:viewDictionary];
    [self.scrollView addConstraints:verticalLayoutConstraintsForContentView];
    [self.scrollView addConstraints:horizontalLayoutConstraintsForContentView];

    NSArray *verticalLayoutConstraintsForSubviews = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleView(titleHeight)][_bodyView]-(contentViewRemainder)-|" options:0 metrics:@{@"titleHeight" : @(titleHeight), @"contentViewRemainder" : @(contentViewRemainder)} views:viewDictionary];
    
    CGFloat screenWidth = self.view.frame.size.width;
    
    NSArray *horizontalTitleViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleView(w)]" options:0 metrics:@{@"w" : @(screenWidth)} views:viewDictionary];
    NSArray *horizontalBodyViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bodyView(w)]|" options:0 metrics:@{@"w" : @(screenWidth)} views:viewDictionary];
    
    [self.contentView addConstraints:horizontalBodyViewConstraints];
    [self.contentView addConstraints:horizontalTitleViewConstraints];
    [self.contentView addConstraints:verticalLayoutConstraintsForSubviews];
    
    //FIXME: These need to not be hard coded.
    NSArray *horizontalLayoutConstraintsForFullTitle = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[_titleLabel]-(100)-|" options:0 metrics:nil views:viewDictionary];
    NSArray *verticalLayoutConstraintsForFullTitle = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel]-(20)-|" options:0 metrics:nil views:viewDictionary];
    
    [self.titleView addConstraints:horizontalLayoutConstraintsForFullTitle];
    [self.titleView addConstraints:verticalLayoutConstraintsForFullTitle];
    
    [self.contentView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    [self.contentView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
}

/**
 *  Supports constraining of buttons based on number required.
 */
-(void)updateButtonViewConstraints {
    
        [self.buttonView removeConstraints:self.buttonView.constraints];
        
        for (NSString* key in self.viewsDictionary) {
            UIView *view = (UIView *)[self.viewsDictionary objectForKey:key];
            
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [view removeConstraints:view.constraints];
        }
        
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.buttonView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44.0];
        
        [self.buttonView addConstraint:heightConstraint];
        
        NSArray *horizontalButtonConstraints;
        NSArray *verticalButtonConstraints;
        
        switch (self.buttonCount) {
                
            case 0:
                break; //no buttons to add
                
            case 1: {
                
                horizontalButtonConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button0]|" options:0 metrics:nil views:self.viewsDictionary];
                
                verticalButtonConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button0(==44)]|" options:0 metrics:nil views:self.viewsDictionary];
                
                break;
            }
                
            case 2: {
                
                horizontalButtonConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button0][button1(==button0)]|" options:0 metrics:nil views:self.viewsDictionary];
                
                NSArray * buttonOneVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[button0](==44)|" options:0 metrics:nil views:self.viewsDictionary];
                
                NSArray *buttonTwoVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[button1](==44)|" options:0 metrics:nil views:self.viewsDictionary];
                
                verticalButtonConstraints = [buttonOneVerticalConstraints arrayByAddingObjectsFromArray:buttonTwoVerticalConstraints];
                break;
            }
        }
        
        [self.buttonView addConstraints:horizontalButtonConstraints];
        [self.buttonView addConstraints:verticalButtonConstraints];
}

- (NSDictionary *)viewsDictionary {
    if (!_viewsDictionary) {
        _viewsDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return _viewsDictionary;
}

/**
 *  Creates buttons for card
 */
- (void)setupButtonsAsNeeded {
    
    for (NSInteger i = 0; i < [self buttonCount]; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:NSSelectorFromString([NSString stringWithFormat:@"button%ldTapped",(long)i]) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:self.card.stringRepresentationOfActionsAvailableForState[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont leoButtonFont];
        button.backgroundColor = self.card.tintColor;
        [self.buttonView addSubview:button];
        
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        button.titleLabel.font = [UIFont leoBodyBoldFont];
        
        
        [self.viewsDictionary setValue:button forKey:[NSString stringWithFormat:@"button%ld",(long)i]];
    }
}


/**
 *  Counts buttons on card based on actionsAvailableForState method in LEOCard object
 *
 *  @return NSInteger count of buttons
 */
- (NSInteger)buttonCount {
    return [self.card.actionsAvailableForState count];
}


- (void)dismiss {
    [self.card returnToPriorState];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [UIView animateWithDuration:0.2 animations:^{
        }];
    }];
}


/**
 *  Abstract method for supporting the action of button1 on an expanded card
 *
 */
- (void)button0Tapped {
    
    [self.delegate button0Tapped];
}

/**
 *  Abstract method for supporting the action of button1 on an expanded card
 *
 */
- (void)button1Tapped {
    [self.delegate button1Tapped];
}

@end

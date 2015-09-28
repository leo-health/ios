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
#import "LEOFeedTVC.h"

@interface LEOExpandedCardViewController ()

@property (strong, nonatomic) UILabel *expandedTitleLabel;
@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UIView *contentView;
@property (nonatomic) BOOL constraintsAlreadyUpdated;
@property (strong, nonatomic) CALayer *buttonLayer;
@property (strong, nonatomic) NSArray *horizontalBodyViewConstraints;

@end

@implementation LEOExpandedCardViewController


#pragma mark - View Controller Lifecycle & Helpers
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    [self setupButton];
    [self setupNavBar];
    
    self.view.clipsToBounds = YES;
    self.scrollView.delegate = self;
    self.titleView.backgroundColor = self.card.tintColor; //TODO: Will ultimately be a gradient of the tintColor with some calculation in a separate image extension class, but for now, this will suffice.

    self.contentView.backgroundColor = [UIColor whiteColor];
}

-(void)setExpandedFullTitle:(NSString *)expandedFullTitle {
    _expandedFullTitle = expandedFullTitle;
    
    self.expandedTitleLabel.text = _expandedFullTitle;
}

- (void)setupSubviews {
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.bounces = YES;
    self.view.backgroundColor = self.card.tintColor;
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];

    self.contentView = [[UIView alloc] init];
    
    self.titleView = [[UIView alloc] init];
    self.expandedTitleLabel = [[UILabel alloc] init];
    
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView addSubview:self.titleView];
    
    [self.titleView addSubview:self.expandedTitleLabel];
}


/**
 *  Creates button for card
 */
- (void)setupButton {
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.button];
    [self.button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.button setTitle:self.card.stringRepresentationOfActionsAvailableForState[0] forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont leoButtonLabelsAndTimeStampsFont];
    self.button.backgroundColor = self.card.tintColor;
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.button addObserver:self forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:nil];
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
    [dismissButton setTintColor:[UIColor leoWhite]];
    
    UIBarButtonItem *dismissBBI = [[UIBarButtonItem alloc] initWithCustomView:dismissButton];
    self.navigationItem.rightBarButtonItem = dismissBBI;

    UILabel *navBarTitleLabel = [[UILabel alloc] init];
    
    //TODO: Remove this line when done prepping this abstract class and have moved over to complete project.
    navBarTitleLabel.text = self.card.title;
    
    navBarTitleLabel.textColor = [UIColor leoWhite];
    navBarTitleLabel.font = [UIFont leoMenuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    
    [navBarTitleLabel sizeToFit]; //MARK: not sure this is useful anymore now that we have added autolayout.
    
    self.navigationItem.titleView = navBarTitleLabel;
    self.navigationItem.titleView.alpha = 0;
    
    self.expandedTitleLabel.text = self.expandedFullTitle;
    self.expandedTitleLabel.font = [UIFont leoExpandedCardHeaderFont];
    self.expandedTitleLabel.textColor = [UIColor leoWhite];
    self.expandedTitleLabel.numberOfLines = 0;
    self.expandedTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
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

    CGFloat percentTitleViewHidden = self.scrollView.contentOffset.y / self.titleView.frame.size.height;
    
    if (percentTitleViewHidden > 0.5) {
        self.navigationItem.titleView.alpha = 1;
    }

}

#pragma mark - <ScrollViewDelegate>
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.scrollView) {
        CGFloat percentTitleViewHidden = scrollView.contentOffset.y / self.titleView.frame.size.height;
        
        if (percentTitleViewHidden < 1) {
            self.expandedTitleLabel.alpha = 1 - percentTitleViewHidden * 2; //FIXME: Magic number
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
            [self animateAlphaLevelsOfView:self.expandedTitleLabel to:0 withDuration:0.1];
            [self animateAlphaLevelsOfView:self.navigationItem.titleView to:1 withDuration:0.1];
        } else {
            
            [self animateScrollViewTo:0 withDuration:0.1];
            [self animateAlphaLevelsOfView:self.expandedTitleLabel to:1 withDuration:0.1];
            [self animateAlphaLevelsOfView:self.navigationItem.titleView to:0 withDuration:0.1];
        }
    }
}

- (void)animateAlphaLevelsOfView:(UIView *)view to:(NSUInteger)level withDuration:(NSTimeInterval)duration {
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        view.alpha = level;
    } completion:nil];
}

- (void)animateScrollViewTo:(CGFloat)y withDuration:(NSTimeInterval)duration {
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.scrollView setContentOffset:CGPointMake(0.0, y)];
    } completion:nil];
}

#pragma mark - Constraints


-(void)updateViewConstraints {
    
    if (!self.constraintsAlreadyUpdated && self.button && self.bodyView) {
        
        [self updateScrollViewConstraints];
        
        self.constraintsAlreadyUpdated = YES;
    }

    [self updateHorizontalBodyConstraints];
    [super updateViewConstraints];
}


- (void)updateHorizontalBodyConstraints {
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_titleView, _button, _bodyView, _scrollView, _contentView, _expandedTitleLabel);

    [self.contentView removeConstraints:self.horizontalBodyViewConstraints];
    
    CGFloat screenWidth = self.view.frame.size.width;
    
    self.horizontalBodyViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bodyView(w)]|" options:0 metrics:@{@"w" : @(screenWidth)} views:viewDictionary];

    [self.contentView addConstraints:self.horizontalBodyViewConstraints];
    
    
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
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    self.bodyView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleView.translatesAutoresizingMaskIntoConstraints = NO;
    self.expandedTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    //TODO: Remove magic number.
    CGFloat titleHeight = 150.0;
    
    //TODO: Need to figure out how to set this via calculation. Based on research so far, the bodyView, which we would like to use to help with the calculation has a frame that is set at 600 x 536, which obviously isn't yet taking into account the constraints on it.
    CGFloat contentViewRemainder = 0;
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_titleView, _button, _bodyView, _scrollView, _contentView, _expandedTitleLabel);
    
    NSArray *verticalLayoutConstraintsForScrollView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView][_button(==44)]|" options:0 metrics:nil views:viewDictionary];
    NSArray *horizontalLayoutConstraintsForScrollView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:0 metrics:nil views:viewDictionary];
    NSArray *horizontalLayoutConstraintsForButtonView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_button]|" options:0 metrics:nil views:viewDictionary];
    
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
    self.horizontalBodyViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bodyView(w)]|" options:0 metrics:@{@"w" : @(screenWidth)} views:viewDictionary];
    
    [self.contentView addConstraints:self.horizontalBodyViewConstraints];
    [self.contentView addConstraints:horizontalTitleViewConstraints];
    [self.contentView addConstraints:verticalLayoutConstraintsForSubviews];
    
    //FIXME: These need to not be hard coded.
    NSArray *horizontalLayoutConstraintsForFullTitle = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[_expandedTitleLabel]-(100)-|" options:0 metrics:nil views:viewDictionary];
    NSArray *verticalLayoutConstraintsForFullTitle = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_expandedTitleLabel]-(20)-|" options:0 metrics:nil views:viewDictionary];
    
    [self.titleView addConstraints:horizontalLayoutConstraintsForFullTitle];
    [self.titleView addConstraints:verticalLayoutConstraintsForFullTitle];
    
//    [self.contentView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
//    [self.contentView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
}




- (void)dismiss {
    
    [self.card returnToPriorState];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [self.delegate takeResponsibilityForCard:self.card];
    }];
}




/**
 *  Abstract method for supporting the button action on an expanded card
 *
 */
- (void)buttonTapped {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}


- (void)toggleButtonValidated:(BOOL)validated {
    
    if (validated) {
        [self.button setBackgroundColor:self.card.tintColor];
        [self.buttonLayer removeFromSuperlayer];
        self.button.enabled = YES;
    } else {
        [self.button setBackgroundColor:[UIColor leoGrayForMessageBubbles]];
        [self.button.layer addSublayer:self.buttonLayer];
        self.button.enabled = NO;
    }
}

-(CALayer *)buttonLayer {
    
    if (!_buttonLayer) {
        
        _buttonLayer = [CALayer layer];
        _buttonLayer.frame = CGRectMake(0.0f, 0.0f, self.button.frame.size.width, 1.0);
        _buttonLayer.borderColor = [UIColor leoGrayForPlaceholdersAndLines].CGColor;
        _buttonLayer.borderWidth = 1.0;
    }
    
    return _buttonLayer;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.button && [keyPath isEqualToString:@"enabled"] ) {
        
    }
}

- (void)dealloc {
    
    [self.button removeObserver:self forKeyPath:@"enabled"];
}


@end

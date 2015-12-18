//
//  StickyView.m
//  NewStickyHeader
//
//  Created by Zachary Drossman on 9/25/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "StickyView.h"
#import "UIImage+Extensions.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingScrollView.h>
@interface StickyView()


@property (strong, nonatomic) UIView *bodyView;
@property (strong, nonatomic) UILabel *expandedTitleLabel;
@property (strong, nonatomic) UILabel *collapsedTitleLabel;
@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) CALayer *buttonLayer;
@property (strong, nonatomic) UIImageView *collapsedGradientImageView;
@property (strong, nonatomic) UIImageView *expandedGradientImageView;
@property (strong, nonatomic) UINavigationBar *navigationBar;
@property (strong, nonatomic) UIViewController *associatedViewController;
@property (strong, nonatomic) CAShapeLayer *pathLayer;
@property (strong, nonatomic) UIButton *continueButton;

@property (nonatomic) BOOL expanded;
@property (nonatomic) BOOL scrollable;

@property (nonatomic) BOOL alreadyUpdatedConstraints;

@property (strong, nonatomic) NSLayoutConstraint *heightLayoutConstraintForTitleView;
@end

@implementation StickyView

CGFloat const expandedTitleViewHeight = 165.0;

IB_DESIGNABLE
-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self commonInit];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    
    [self initializeSubviews];
    [self setupScrollView];
    
    self.collapsedGradientImageView.hidden = YES;
}


-(void)scrollviewTapped:(UIGestureRecognizer*)gesture{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)formatTitles {
    
    [self setupExpandedTitleLabel];
    [self setupCollapsedTitleLabel];
}

- (void)setupExpandedTitleLabel {
    
    self.expandedTitleLabel.font = [UIFont leo_expandedCardHeaderFont];
    self.expandedTitleLabel.textColor = [UIColor leo_grayForTitlesAndHeadings];
    self.expandedTitleLabel.numberOfLines = 0;
    self.expandedTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.expandedTitleLabel.text = [self.delegate expandedTitleViewContent];
}

- (void)setupCollapsedTitleLabel {
    
    self.collapsedTitleLabel.font = [UIFont leo_menuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    self.collapsedTitleLabel.textColor = [UIColor leo_grayForTitlesAndHeadings];
    self.collapsedTitleLabel.text = [self.delegate collapsedTitleViewContent];
    self.collapsedTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.collapsedTitleLabel sizeToFit];
}

- (void)setupNavigationBar {
    
    [self.navigationBar setBackgroundImage:[UIImage leo_imageWithColor:[UIColor clearColor]]
                                forBarPosition:UIBarPositionAny
                                    barMetrics:UIBarMetricsDefault];
    
    [self.navigationBar setShadowImage:[UIImage new]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //TODO: While this works just fine, the warning should be silenced, or an alternative method used.
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wundeclared-selector"
    [backButton addTarget:self.associatedViewController action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
#pragma clang diagnostic pop
    
    [backButton setImage:[UIImage imageNamed:@"Icon-BackArrow"] forState:UIControlStateNormal];
    [backButton sizeToFit];
//    [backButton setTintColor:[UIColor leo_orangeRed]];
    
    UIBarButtonItem *backBBI = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    item.leftBarButtonItem = backBBI;
    [self.navigationBar pushNavigationItem:item animated:NO];
}

- (void)reloadViews {
    
    self.bodyView = [self.delegate stickyViewBody];
    self.associatedViewController = [self.delegate associatedViewController];
    
    [self.continueButton setBackgroundImage:[UIImage leo_imageWithColor:self.tintColor] forState:UIControlStateNormal];
    self.continueButton.layer.borderColor = self.tintColor.CGColor;

    [self formatTitles];

    [self setupConstraints];
    
    [self setupNavigationBar];
    
    self.expanded = [self.delegate initialStateExpanded];
    self.scrollable = [self.delegate scrollable];

    self.expandedGradientImageView.image = [self.delegate expandedGradientImage];
    self.collapsedGradientImageView.image = [self.delegate collapsedGradientImage];
}


-(void)setExpanded:(BOOL)expanded {
    
    _expanded = expanded;
    
    if (!expanded) {
        self.collapsedTitleLabel.alpha = 1;
        self.expandedTitleLabel.alpha = 0;
    } else {
        self.collapsedTitleLabel.alpha = 0;
        self.expandedTitleLabel.alpha = 1;
    }
}

-(void)setScrollable:(BOOL)scrollable {
    _scrollable = scrollable;
    
    if (scrollable) {
        self.scrollView.scrollEnabled = YES;
    } else {
        self.scrollView.scrollEnabled = NO;
    }
}

- (void)setupScrollView {
    
    self.scrollView.delegate = self;
    
    UITapGestureRecognizer *tapGestureForTextFieldDismissal = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollviewTapped:)];
    tapGestureForTextFieldDismissal.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:tapGestureForTextFieldDismissal];
}

- (void)initializeSubviews {
    
    self.contentView = [[UIView alloc] init];
    self.titleView = [[UIView alloc] init];
    self.expandedTitleLabel = [[UILabel alloc] init];
    self.collapsedTitleLabel = [[UILabel alloc] init];
    self.scrollView = [[TPKeyboardAvoidingScrollView alloc] init];
    self.collapsedGradientImageView = [[UIImageView alloc] init];
    self.expandedGradientImageView = [[UIImageView alloc] init];
    self.navigationBar = [[UINavigationBar alloc] init];
    
    //MARK: This isn't great code. Let's go back and clean this up later.
    [self setupContinueButton];
    
    [self.scrollView addSubview:self.contentView];

    [self addSubview:self.scrollView];
    [self addSubview:self.collapsedGradientImageView];
    [self addSubview:self.collapsedTitleLabel];
    [self addSubview:self.navigationBar];
    
    [self.titleView addSubview:self.expandedGradientImageView];
    [self.titleView addSubview:self.expandedTitleLabel];
}

- (void)setupContinueButton {
    
    UIButton *starterButton = [UIButton buttonWithType:UIButtonTypeCustom];

    self.continueButton = [self.delegate formatContinueButton:starterButton];
    
    if (!self.continueButton) {
        self.continueButton = starterButton;
        
        [self.continueButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
        
        self.continueButton.layer.borderColor = self.tintColor.CGColor;
        self.continueButton.layer.borderWidth = 1.0;
        
        self.continueButton.titleLabel.font = [UIFont leo_buttonLabelsAndTimeStampsFont];
        [self.continueButton setTitleColor:[UIColor leo_white] forState:UIControlStateNormal];
        [self.continueButton setBackgroundImage:[UIImage leo_imageWithColor:self.tintColor] forState:UIControlStateNormal];
    }
    
    [self.continueButton addTarget:self.associatedViewController action:@selector(continueTapped:) forControlEvents:UIControlEventTouchUpInside];
}

//MARK: Leaving commented code here as we have not committed it anywhere. This autolayout code would effectively move the titleView out from the scrollView if we want to go ahead and move constraints. Turned out this was harder than originally thought, but we might want to do it eventually in order to get to a place where keyboard avoiding works as we would like. (There are other options for discussion eventually too.) We can take this commented autolayout code out when a) we have moved StickyView into a xib, or b) we have sorted out keyboard avoiding in a way that supports our stickyheader.
- (void)setupConstraints {
    
    [self.contentView addSubview:self.bodyView];
    [self.contentView addSubview:self.titleView];
    [self.contentView addSubview:self.continueButton];
//    [self addSubview:self.titleView];
    [self removeConstraints:self.constraints];
    [self.scrollView removeConstraints:self.scrollView.constraints];
    [self.contentView removeConstraints:self.contentView.constraints];
    [self.titleView removeConstraints:self.titleView.constraints];
    
    self.titleView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.expandedTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.bodyView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collapsedTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.collapsedGradientImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.expandedGradientImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.continueButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    //TODO: Remove magic number.
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_titleView, _scrollView, _contentView, _expandedTitleLabel, _bodyView, _collapsedTitleLabel, _collapsedGradientImageView, _expandedGradientImageView, _navigationBar, _continueButton);
    
//   NSArray *verticalLayoutConstraintsForScrollView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleView(titleHeight)][_scrollView]|" options:0 metrics:@{@"titleHeight":@(expandedTitleViewHeight)} views:viewDictionary];

    NSArray *verticalLayoutConstraintsForScrollView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|" options:0 metrics:nil views:viewDictionary];

//    NSLayoutConstraint *topLayoutConstraintForTitleView = [NSLayoutConstraint constraintWithItem:self.titleView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
//    self.heightLayoutConstraintForTitleView = [NSLayoutConstraint constraintWithItem:self.titleView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:expandedTitleViewHeight];
//    NSLayoutConstraint *bottomLayoutConstraintForTitleView = [NSLayoutConstraint constraintWithItem:self.titleView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.scrollView.contentOffset.y];
//    NSLayoutConstraint *bottomLayoutConstraintForScrollView = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    NSArray *horizontalLayoutConstraintsForScrollView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:0 metrics:nil views:viewDictionary];
    NSArray *horizontalLayoutConstraintsForTitleView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleView]|" options:0 metrics:nil views:viewDictionary];
    
    NSArray *horizontalLayoutConstraintsForNavigationBar = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_navigationBar]|" options:0 metrics:nil views:viewDictionary];
    NSArray *verticalLayoutConstraintsForNavigationBar = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_navigationBar(==44)]" options:0 metrics:nil views:viewDictionary];
    
    [self addConstraints:horizontalLayoutConstraintsForNavigationBar];
    [self addConstraints:verticalLayoutConstraintsForNavigationBar];
    
    NSArray *horizontalLayoutConstraintsForFakeNavImageView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collapsedGradientImageView]|" options:0 metrics:nil views:viewDictionary];
    NSArray *verticalLayoutConstraintsForFakeNavImageView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collapsedGradientImageView(==64)]" options:0 metrics:nil views:viewDictionary];

//    [self addConstraints:@[topLayoutConstraintForTitleView, bottomLayoutConstraintForScrollView, self.heightLayoutConstraintForTitleView, bottomLayoutConstraintForTitleView]];
    [self addConstraints:horizontalLayoutConstraintsForScrollView];
    [self addConstraints:horizontalLayoutConstraintsForTitleView];
    [self addConstraints:verticalLayoutConstraintsForScrollView];
    [self addConstraints:horizontalLayoutConstraintsForFakeNavImageView];
    [self addConstraints:verticalLayoutConstraintsForFakeNavImageView];
    
    NSArray *verticalLayoutConstraintsForContentView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|" options:0 metrics:nil views:viewDictionary];
    NSArray *horizontalLayoutConstraintsForContentView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|" options:0 metrics:nil views:viewDictionary];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    
    [self.scrollView addConstraints:verticalLayoutConstraintsForContentView];
    [self.scrollView addConstraints:horizontalLayoutConstraintsForContentView];
    
    NSArray *verticalLayoutConstraintsForSubviews = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleView(titleHeight)][_bodyView]-(20)-[_continueButton(==54)]-(20)-|" options:0 metrics:@{@"titleHeight":@(expandedTitleViewHeight)} views:viewDictionary];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bodyView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:30]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bodyView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-30]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.continueButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:30]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.continueButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-30]];
    
    [self.contentView addConstraints:verticalLayoutConstraintsForSubviews];
    
    //FIXME: These need to not be hard coded.
    NSArray *horizontalLayoutConstraintsForExpandedTitle = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(30)-[_expandedTitleLabel]-(100)-|" options:0 metrics:nil views:viewDictionary];
    NSArray *verticalLayoutConstraintsForExpandedTitle = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_expandedTitleLabel]|" options:0 metrics:nil views:viewDictionary];
    
    [self.titleView addConstraints:horizontalLayoutConstraintsForExpandedTitle];
    [self.titleView addConstraints:verticalLayoutConstraintsForExpandedTitle];
    
    NSArray *horizontalLayoutConstraintsForExpandedGradientImageView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_expandedGradientImageView]|" options:0 metrics:nil views:viewDictionary];
    NSArray *verticalLayoutConstraintsForExpandedGradientImageView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_expandedGradientImageView]|" options:0 metrics:nil views:viewDictionary];
    
    [self.titleView addConstraints:horizontalLayoutConstraintsForExpandedGradientImageView];
    [self.titleView addConstraints:verticalLayoutConstraintsForExpandedGradientImageView];
    
    
    //TODO: Figure out how to make this part of the UINavigationBar instead of placing here. All methods attempted do not center the text in the UINavigationBar.
    NSArray *horizontalLayoutConstraintsForCollapsedTitle = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collapsedTitleLabel]|" options:0 metrics:nil views:viewDictionary];
    NSArray *verticalLayoutConstraintsForCollapsedTitle = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(26)-[_collapsedTitleLabel]" options:0 metrics:nil views:viewDictionary];
    
    [self addConstraints:horizontalLayoutConstraintsForCollapsedTitle];
    [self addConstraints:verticalLayoutConstraintsForCollapsedTitle];
}

//MARK: This method is not being used, but would be if we were to move the title out from the scrollview. I am leaving it for the same reason as described in the above MARK.
//- (void)updateHeightConstraintWithHeight:(CGFloat)height {
//    
//    [self removeConstraint:self.heightLayoutConstraintForTitleView];
//    self.heightLayoutConstraintForTitleView = [NSLayoutConstraint constraintWithItem:self.titleView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height];
//    
//    [self addConstraint:self.heightLayoutConstraintForTitleView];
//}

#pragma mark - <ScrollViewDelegate>

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.scrollView) {
        CGFloat percentTitleViewHidden = scrollView.contentOffset.y / self.titleView.frame.size.height;
        
        if (percentTitleViewHidden < 1) {
            self.expandedTitleLabel.alpha = 1 - percentTitleViewHidden * 2; //FIXME: Magic number
            self.collapsedTitleLabel.alpha = percentTitleViewHidden;
        }
        
        if (scrollView.contentOffset.y >= expandedTitleViewHeight - 64) {
            if (self.collapsedGradientImageView.hidden == YES) {
                [self drawBorders:YES];
            }
            self.collapsedGradientImageView.hidden = NO;

        } else {
            

            if (self.collapsedGradientImageView.hidden == NO) {
            [self drawBorders:NO];
            }
            
            self.collapsedGradientImageView.hidden = YES;
        }
    }
}

- (void)drawBorders:(BOOL)shouldDraw {
    
    if (shouldDraw) {
        
        CGRect viewRect = self.collapsedGradientImageView.bounds;
        
        CGPoint beginningOfLine = CGPointMake(viewRect.origin.x, viewRect.origin.y + viewRect.size.height);
        CGPoint endOfLine = CGPointMake(viewRect.origin.x + viewRect.size.width, viewRect.origin.y + viewRect.size.height);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:beginningOfLine];
        [path addLineToPoint:endOfLine];
        
        self.pathLayer = [CAShapeLayer layer];
        self.pathLayer.frame = self.bounds;
        self.pathLayer.path = path.CGPath;
        self.pathLayer.strokeColor = [UIColor leo_white].CGColor;
        self.pathLayer.lineWidth = 1.0f;
        self.pathLayer.lineJoin = kCALineJoinBevel;
        
        [self.layer addSublayer:self.pathLayer];
        
        CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"breakerFade"];
        fadeAnimation.duration = 0.3;
        fadeAnimation.fromValue = (id)[UIColor leo_white].CGColor;
        fadeAnimation.toValue = (id)[UIColor leo_orangeRed].CGColor;

        self.pathLayer.strokeColor = [UIColor leo_orangeRed].CGColor;
        [self.pathLayer addAnimation:fadeAnimation forKey:@"breakerFade"];
        
    } else {
        
        CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"breakerFade"];
        fadeAnimation.duration = 0.3;
        fadeAnimation.fromValue = (id)[UIColor leo_orangeRed].CGColor;
        fadeAnimation.toValue = (id)[UIColor leo_white].CGColor;
        
        self.pathLayer.strokeColor = [UIColor leo_white].CGColor;
        [self.pathLayer addAnimation:fadeAnimation forKey:@"breakerFade"];
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        [self stoppedScrolling];
//        [self updateNavBarShadowForScrollView:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (scrollView == self.scrollView) {

        if (!decelerate) {
            [self stoppedScrolling];
//            [self updateNavBarShadowForScrollView:scrollView];
        }
    }
}

- (void)updateNavBarShadowForScrollView:(UIScrollView *)scrollView {
    
    if ((scrollView.contentOffset.y + scrollView.contentInset.top + scrollView.contentInset.bottom) > 20) {
        [self.navigationBar setShadowImage:[UIImage leo_imageWithColor:[UIColor leo_orangeRed]]];

        [UIView animateWithDuration:0.1 animations:^{
            [self layoutIfNeeded];
        }];
    } else {
        [self.navigationBar setShadowImage:[UIImage new]];

        [UIView animateWithDuration:0.1 animations:^{
            [self layoutIfNeeded];
        }];
    }
}

//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [self.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor leo_orangeRed]]];
//
//    [UIView animateWithDuration:0.1 animations:^{
//        [self layoutIfNeeded];
//    }];
//}

#pragma mark - Scroll helpers
- (void)stoppedScrolling {
    
    CGFloat percentTitleViewHidden = self.scrollView.contentOffset.y / self.titleView.frame.size.height;
    
    if (percentTitleViewHidden < 1.0) {
        if (percentTitleViewHidden > 0.5) {
            
            [self animateScrollViewTo:(self.titleView.frame.size.height - 64) withDuration:0.1];
                        [self animateAlphaLevelsOfView:self.expandedTitleLabel to:0 withDuration:0.1];
                        [self animateAlphaLevelsOfView:self.collapsedTitleLabel to:1 withDuration:0.1];
        } else {
            
            [self drawBorders:NO];

            [self animateScrollViewTo:0 withDuration:0.2];
                        [self animateAlphaLevelsOfView:self.expandedTitleLabel to:1 withDuration:0.1];
                        [self animateAlphaLevelsOfView:self.collapsedTitleLabel to:0 withDuration:0.1];
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


@end

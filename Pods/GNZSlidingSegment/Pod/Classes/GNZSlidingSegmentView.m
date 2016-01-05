//
//  GNZSegmentedController.m
//  Pods
//
//  Created by Chris Gonzales on 11/18/15.
//
//

#import "GNZSlidingSegmentView.h"

typedef NS_ENUM(NSUInteger, ScrollDirection) {

    ScrollDirectionLeft = 1,
    ScrollDirectionRight = 2
};

@interface GNZSlidingSegmentView () <UIScrollViewDelegate>
@property (weak, nonatomic) UIScrollView *scrollView;
@property (nonatomic) id<GNZSegment> feedSelectorControl;
@property (nonatomic) BOOL alreadyUpdatedConstraints;
@property (nonatomic) CGFloat lastContentOffsetX;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) BOOL isResponsibleForSegmentChange;

@end
@implementation GNZSlidingSegmentView

#pragma mark - Setup

- (void)connectSegmentedControl {
    if (_feedSelectorControl != [self.dataSource segmentedControlForSlidingSegmentView:self]) {
        _feedSelectorControl = [self.dataSource segmentedControlForSlidingSegmentView:self];
        [(id)_feedSelectorControl addTarget:self action:@selector(segmentSelectionDidChange:) forControlEvents:UIControlEventValueChanged];
        self.scrollView.delegate = self;
    }
}

- (void)updateConstraints {

    if (!self.alreadyUpdatedConstraints && [self viewControllerForIndex:0]) {

        NSMutableDictionary *views;
        for (int count = 0; count < [self segmentViewControllerCount]; count++) {
            UIViewController *previousVC = count ? [self viewControllerForIndex:count-1] : nil;
            UIViewController *currentVC = [self viewControllerForIndex:count];
            [currentVC.view setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self.scrollView addSubview:currentVC.view];

            views = [[NSMutableDictionary alloc] initWithDictionary:@{@"scrollView": self.scrollView}];
            views[@"currentVC"] = currentVC.view;
            if (previousVC) views[@"previousVC"] = previousVC.view;

            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[currentVC(==scrollView)]" options:0 metrics:nil views:views]];
            if (count == 0) {
                [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[currentVC]" options:0 metrics:nil views:views]];
            } else {
                [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousVC][currentVC]" options:0 metrics:nil views:views]];
            }
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[currentVC(==scrollView)]|" options:0 metrics:nil views:views]];
        }
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[currentVC]|" options:0 metrics:nil views:views]];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateConstraints];
}

- (void)reload {
    [self connectSegmentedControl];

    self.alreadyUpdatedConstraints = NO;
    [self setNeedsUpdateConstraints];
}

#pragma mark - Overrides

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *strongScrollView = [[UIScrollView alloc] init];
        _scrollView = strongScrollView;
        _scrollView.backgroundColor = [UIColor colorWithRed:224 green:224 blue:224 alpha:1.0];
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];

        NSDictionary *views = NSDictionaryOfVariableBindings(_scrollView);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:0 metrics:nil views:views]];

    }
    return _scrollView;
}

- (void)setDataSource:(id<GNZSlidingSegmentViewDatasource>)dataSource {
    _dataSource = dataSource;
    if (_dataSource) {
        [self reload];
    }
}

#pragma mark - Datasource Convenience
- (NSUInteger)segmentViewControllerCount {
    return [self.feedSelectorControl numberOfSegments];
}

- (UIViewController *)viewControllerForIndex:(NSUInteger)index {
    return [self.dataSource slidingSegmentView:self viewControllerForSegmentAtIndex:index];
}

#pragma mark - Actions
-(void)segmentSelectionDidChange:(id)sender
{
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * [(id)self.feedSelectorControl selectedSegmentIndex];
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

#pragma mark - UIScrollView Delegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    self.lastContentOffsetX = scrollView.contentOffset.x;
    self.currentPage = [self currentPageForScrollView:scrollView];
    self.isResponsibleForSegmentChange = YES;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    ScrollDirection currentScrollDirection;

    if (scrollView.contentOffset.x > self.lastContentOffsetX) {
        currentScrollDirection = ScrollDirectionRight;
    }

    if (scrollView.contentOffset.x < self.lastContentOffsetX) {
        currentScrollDirection = ScrollDirectionLeft;
    }

    if (self.isResponsibleForSegmentChange) {

        if (!([self currentPageForScrollView:scrollView] == self.currentPage)) {

            currentScrollDirection == ScrollDirectionRight ? self.feedSelectorControl.selectedSegmentIndex ++ : self.feedSelectorControl.selectedSegmentIndex -- ;

            self.currentPage = [self currentPageForScrollView:scrollView];

            if ([self.feedSelectorControl respondsToSelector:@selector(adjustIndicatorForScroll:)]) {

                [(id <GNZSegment>)self.feedSelectorControl adjustIndicatorForScroll:scrollView];
            }
        }
    }

    self.lastContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    [self.delegate slidingSegmentView:self segmentDidChange:[self.feedSelectorControl selectedSegmentIndex]];
    self.isResponsibleForSegmentChange = NO;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

    [self.delegate slidingSegmentView:self segmentDidChange:[self.feedSelectorControl selectedSegmentIndex]];
    self.isResponsibleForSegmentChange = NO;
}

- (NSInteger) currentPageForScrollView:(UIScrollView *)scrollView
{
    CGFloat currentX = scrollView.contentOffset.x+self.frame.size.width/2;
    CGFloat currentPage = (currentX/self.frame.size.width);
    if (currentPage < 0)
        currentPage = 0;
    if (currentPage >= [self.feedSelectorControl numberOfSegments])
        currentPage = [self.feedSelectorControl numberOfSegments]-1;
    return currentPage;
}

@end

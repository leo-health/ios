//
//  LEOPHRViewController.m
//  Leo
//
//  Created by Zachary Drossman on 12/27/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOPHRViewController.h"
#import "LEOPHRHeaderView.h"
#import "LEORecordViewController.h"
#import "LEOStyleHelper.h"

#import <GNZSlidingSegment/GNZSegmentedControl.h>
#import <GNZSlidingSegment/GNZSlidingSegmentView.h>
#import "LEORecordViewController.h"
#import <GNZSlidingSegment/UISegmentedControl+GNZCompatibility.h>

#import "Patient.h"

#import "UIColor+LeoColors.h"

static CGFloat const kHeightOfHeaderPHR = 200;

@interface LEOPHRViewController () <GNZSlidingSegmentViewDatasource, GNZSlidingSegmentViewDelegate, LEOStickyHeaderDataSource, LEOStickyHeaderDelegate>

@property (weak, nonatomic) LEOPHRHeaderView *headerView;

@property (weak, nonatomic) GNZSegmentedControl *segmentedControl;
@property (nonatomic) GNZSlidingSegmentView *slidingSegmentView;
@property (nonatomic) NSArray *segmentViewControllers;

@property (nonatomic) BOOL alreadyUpdatedConstraints;
@property (strong, nonatomic) NSArray *patients;

@end

@implementation LEOPHRViewController

#pragma mark - VCL & Helper

- (instancetype)initWithPatients:(NSArray *)patients {
    
    self = [super init];
    if (self) {
        _patients = patients;
    }
    return self;
}

-(void)viewDidLoad {

    [super viewDidLoad];

    [Localytics tagScreen:kAnalyticScreenHealthRecord];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.stickyHeaderView.delegate = self;
    self.stickyHeaderView.datasource = self;

    [LEOApiReachability startMonitoringForController:self];
}

- (LEOStickyHeaderView *)stickyHeaderView {

    if (!_stickyHeaderView) {

        _stickyHeaderView = [super stickyHeaderView];
        _stickyHeaderView.headerShouldNotBounceOnScroll = YES;
        _stickyHeaderView.breakerHidden = YES;
    }
    return _stickyHeaderView;
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self setupNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    // LEORecordViewController should handle its own data requests in viewDidAppear
    // TODO: implement VCC (View Controller Containment) 
    for (LEORecordViewController *recordVC in self.segmentViewControllers) {
        [recordVC requestHealthRecord];
    }
}

-(void)setupNavigationBar {

    [LEOStyleHelper styleBackButtonForViewController:self forFeature:FeatureSettings];

    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor leo_white];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

#pragma mark - Accessors

-(LEOPHRHeaderView *)headerView {

    if (!_headerView) {

        LEOPHRHeaderView *strongHeaderView = [[LEOPHRHeaderView alloc] initWithPatients:self.patients];
        _headerView = strongHeaderView;
        _headerView.backgroundColor = [UIColor leo_white];

        // TODO: Remove when subview content is available to size view
        [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_headerView(height)]" options:0 metrics:@{@"height":@(kHeightOfHeaderPHR)} views:NSDictionaryOfVariableBindings(_headerView)]];
    }

    return _headerView;
}

- (NSArray *)segmentViewControllers {

    if (!_segmentViewControllers) {

        NSMutableArray *recordVCs = [NSMutableArray new];

        for (Patient *patient in self.patients) {

            //TODO: ZSD Update once LEORecordViewController is actually built out.
            LEORecordViewController *recordVC = [[LEORecordViewController alloc] init];
            recordVC.patient = patient;
            recordVC.phrViewController = self;
            [recordVCs addObject:recordVC];
        }

        _segmentViewControllers = [recordVCs copy];
    }

    return _segmentViewControllers;
}


-(GNZSlidingSegmentView *)slidingSegmentView {

    if (!_slidingSegmentView) {

        GNZSlidingSegmentView *strongSlidingSegmentView = [GNZSlidingSegmentView new];
        _slidingSegmentView = strongSlidingSegmentView;

        _slidingSegmentView.dataSource = self;
        _slidingSegmentView.delegate = self;
    }
    
    return _slidingSegmentView;
}

#pragma mark - Sticky Header View DataSource

-(UIView *)injectBodyView {
    return self.slidingSegmentView;
}

-(UIView *)injectTitleView {
    return self.headerView;
}

#pragma mark - GNZSlidingSegmentView Datasource

- (id<GNZSegment>)segmentedControlForSlidingSegmentView:(GNZSlidingSegmentView *)segmentPageController {
    return self.headerView.segmentControl;
}

- (UIViewController *)slidingSegmentView:(GNZSlidingSegmentView *)segmentPageController viewControllerForSegmentAtIndex:(NSUInteger)index {
    UIViewController *vc;
    if (index < self.segmentViewControllers.count) {
        vc = self.segmentViewControllers[index];
    }
    return vc;
}

- (NSUInteger)numberOfSegmentsForSlidingSegmentViewController:(GNZSlidingSegmentView *)segmentPageController {
    return self.segmentViewControllers.count;
}

#pragma mark - GNZSlidingSegmentView Delegate
- (void)slidingSegmentView:(GNZSlidingSegmentView *)slidingSegmentView segmentDidChange:(NSUInteger)newSegmentIndex {

    [LEOBreadcrumb crumbWithFunction:__PRETTY_FUNCTION__];

    self.stickyHeaderView.scrollView.contentOffset = CGPointZero;
}


@end

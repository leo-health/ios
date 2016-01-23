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

static CGFloat const kHeightOfHeaderPHR = 100;

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

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.stickyHeaderView.delegate = self;
    self.stickyHeaderView.datasource = self;
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

-(void)setupNavigationBar {

    [LEOStyleHelper styleBackButtonForViewController:self forFeature:FeatureSettings];

    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor leo_white];
}

#pragma mark - Accessors

-(LEOPHRHeaderView *)headerView {

    if (!_headerView) {

        LEOPHRHeaderView *strongHeaderView = [[LEOPHRHeaderView alloc] initWithPatients:self.patients];
        _headerView = strongHeaderView;
        _headerView.backgroundColor = [UIColor leo_white];

        // TODO: Remove when subview content is available to size view
        [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_headerView(height)]" options:0 metrics:@{@"height":@(200)} views:NSDictionaryOfVariableBindings(_headerView)]];
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
            recordVC.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255.0)/255 alpha:1.0];

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
//    [self.headerView didChangeSegmentSelection:newSegmentIndex];
}


@end

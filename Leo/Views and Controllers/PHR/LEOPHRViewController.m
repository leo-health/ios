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

#import <GNZSlidingSegment/GNZSegmentedControl.h>
#import <GNZSlidingSegment/GNZSlidingSegmentView.h>
#import "LEORecordViewController.h"
#import <GNZSlidingSegment/UISegmentedControl+GNZCompatibility.h>

#import "Patient.h"

@interface LEOPHRViewController () <GNZSlidingSegmentViewDatasource, GNZSlidingSegmentViewDelegate>

@property (weak, nonatomic) LEOPHRHeaderView *headerView;

@property (weak, nonatomic) GNZSegmentedControl *segmentedControl;
@property (nonatomic) GNZSlidingSegmentView *slidingSegmentView;
@property (nonatomic) NSArray *segmentViewControllers;

@property (nonatomic) BOOL alreadyUpdatedConstraints;
@property (strong, nonatomic) NSArray *patients;

@end

@implementation LEOPHRViewController

- (instancetype)initWithPatients:(NSArray *)patients {
    
    self = [super init];
    if (self) {
        _patients = patients;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

-(LEOPHRHeaderView *)headerView {

    if (!_headerView) {

        LEOPHRHeaderView *strongHeaderView = [[LEOPHRHeaderView alloc] initWithPatients:self.patients];
        _headerView = strongHeaderView;

        [self.view addSubview:_headerView];
    }

    return _headerView;
}

- (NSArray *)segmentViewControllers {

    if (!_segmentViewControllers) {

        NSMutableArray *recordVCs = [NSMutableArray new];

        for (Patient *patient in self.patients) {

            //TODO: ZSD Update once LEORecordViewController is actually built out.
            LEORecordViewController *recordVC = [[LEORecordViewController alloc] init];
            recordVC.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255.0)/255 alpha:1.0];

            [recordVCs addObject:recordVC];
        }

        _segmentViewControllers = [recordVCs copy];
    }

    return _segmentViewControllers;
}

-(void)updateViewConstraints {

    if (!self.alreadyUpdatedConstraints) {

        [self.view removeConstraints:self.view.constraints];
        self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
        self.slidingSegmentView.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *bindings = NSDictionaryOfVariableBindings(_headerView,_slidingSegmentView);

        NSArray *horizontalConstraintsForPatientSelectorView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_headerView]|" options:0 metrics:nil views:bindings];
        NSArray *horizontalConstraintsForSlidingSegmentView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_slidingSegmentView]|" options:0 metrics:nil views:bindings];


        //TODO: ZSD Determine appropriate way to size header vs. body if constants are not appropriate.

        NSInteger headerViewHeight = 174;
        NSInteger slidingSegmentViewHeight = CGRectGetHeight([UIScreen mainScreen].bounds) - headerViewHeight;

        NSArray *verticalConstraintsForSubviews = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_headerView(headerViewHeight)][_slidingSegmentView(slidingSegmentViewHeight)]|" options:0 metrics:@{ @"headerViewHeight" : @(headerViewHeight), @"slidingSegmentViewHeight" : @(slidingSegmentViewHeight)} views:bindings];

        [self.view addConstraints:horizontalConstraintsForPatientSelectorView];
        [self.view addConstraints:horizontalConstraintsForSlidingSegmentView];
        [self.view addConstraints:verticalConstraintsForSubviews];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateViewConstraints];
}

-(GNZSlidingSegmentView *)slidingSegmentView {

    if (!_slidingSegmentView) {

        GNZSlidingSegmentView *strongSlidingSegmentView = [GNZSlidingSegmentView new];

        _slidingSegmentView = strongSlidingSegmentView;

        [self.view addSubview:_slidingSegmentView];

        _slidingSegmentView.dataSource = self;
        _slidingSegmentView.delegate = self;
    }

    return _slidingSegmentView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.headerView didChangeSegmentSelection:newSegmentIndex];
}


@end

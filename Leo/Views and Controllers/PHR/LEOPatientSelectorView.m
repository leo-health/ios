//
//  LEOPatientSelectorView.m
//  Leo
//
//  Created by Zachary Drossman on 12/27/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOPatientSelectorView.h"
#import "Patient.h"
#import <GNZSegmentedControl.h>
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"

@interface LEOPatientSelectorView ()

@property (strong, nonatomic) NSArray *patients;
@property (weak, nonatomic) UIView *contentView;
@property (nonatomic) BOOL alreadyUpdatedConstraints;
@property (weak, nonatomic) GNZSegmentedControl *segmentedControl;
@property (nonatomic) BOOL isResponsibleForSegmentChange;

@end

@implementation LEOPatientSelectorView

static const CGFloat kHeightSegmentControl = 45.0;
static const CGFloat kDistanceSegments = 26.0;

#pragma mark - VFL & Helper Methods

- (instancetype)initWithPatients:(NSArray *)patients {

    self = [super init];

    if (self) {
        _patients = patients;

        [self.segmentedControl addTarget:self action:@selector(didChangeSegmentSelection:) forControlEvents:UIControlEventValueChanged];
    }

    return self;
}


#pragma mark - Accessors

- (GNZSegmentedControl *)segmentedControl {

    if (!_segmentedControl) {

        NSUInteger segmentCount = [self.patients count];

        GNZSegmentedControl *strongSegmentedControl = [[GNZSegmentedControl alloc] initWithSegmentCount:segmentCount indicatorStyle:GNZIndicatorStyleCustom options:@{GNZSegmentOptionControlBackgroundColor: [UIColor leo_white], GNZSegmentOptionDefaultSegmentTintColor: [[UIColor leo_white] colorWithAlphaComponent:0.5], GNZSegmentOptionSelectedSegmentTintColor: [[UIColor leo_white] colorWithAlphaComponent:1.0], GNZSegmentOptionIndicatorColor: [UIColor leo_white]}];

        strongSegmentedControl.translatesAutoresizingMaskIntoConstraints = NO;

        _segmentedControl = strongSegmentedControl;
        _segmentedControl.backgroundColor = [UIColor clearColor];
        _segmentedControl.font = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont];
        _segmentedControl.segmentDistance = kDistanceSegments;
        _segmentedControl.controlHeight = kHeightSegmentControl;
        
        _segmentedControl.customIndicatorAnimatorBlock = ^void(UIScrollView *scrollView) {

            CGRect selectedSegmentRect = [self.segmentedControl selectedSegmentFrameAdjustedForSpacing];

            CGRect visibleRect = [self.contentView convertRect:self.bounds toView:self.contentView];

            BOOL segmentIsFullyOnScreen = CGRectContainsRect(visibleRect, selectedSegmentRect);

            if (!segmentIsFullyOnScreen) {

                CGRect onScreenRectOfSelectedSegment = CGRectIntersection(visibleRect, selectedSegmentRect);

                CGFloat onScreenWidthPortionOfSelectedSegmentRect = CGRectGetWidth(onScreenRectOfSelectedSegment);

                CGFloat widthOfSelectedSegmentRect = CGRectGetWidth(selectedSegmentRect);

                CGFloat remainingPortionOfSegmentViewToTransitionOnScreen = (widthOfSelectedSegmentRect - onScreenWidthPortionOfSelectedSegmentRect) / widthOfSelectedSegmentRect;

                CGFloat contentOffsetX;

                if (onScreenRectOfSelectedSegment.origin.x > selectedSegmentRect.origin.x) {
                    contentOffsetX = -remainingPortionOfSegmentViewToTransitionOnScreen * CGRectGetWidth(selectedSegmentRect) + self.contentOffset.x;
                } else {
                    contentOffsetX = remainingPortionOfSegmentViewToTransitionOnScreen * CGRectGetWidth(selectedSegmentRect) + self.contentOffset.x;
                }

                [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    [self setContentOffset:CGPointMake(contentOffsetX, self.contentOffset.y) animated:NO];
                } completion:^(BOOL finished) {
                   
                }];

            }
        };
        
        [self.contentView addSubview:_segmentedControl];

        [self.patients enumerateObjectsUsingBlock:^(id  _Nonnull patient, NSUInteger idx, BOOL * _Nonnull stop) {

            [_segmentedControl setTitle:[((Patient *)patient).firstName uppercaseString] forSegmentAtIndex:idx];
        }];
    }
    
    return _segmentedControl;
}

-(UIView *)contentView {

    if (!_contentView) {

        UIView *strongContentView = [UIView new];
        _contentView = strongContentView;

        [self addSubview:_contentView];
    }

    return _contentView;
}


#pragma mark - Layout

- (void)updateConstraints {

    if (!self.alreadyUpdatedConstraints) {

        [self.contentView removeConstraints:self.contentView.constraints];

        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        self.segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *bindings = NSDictionaryOfVariableBindings(_contentView, _segmentedControl);

        NSArray *horizontalConstraintsForContentView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|" options:0 metrics:nil views:bindings];
        NSArray *verticalConstraintsForContentView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|" options:0 metrics:nil views:bindings];

        NSLayoutConstraint *bottomConstraintForContentView = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];

        [self.superview addConstraint:bottomConstraintForContentView];
        [self addConstraints:horizontalConstraintsForContentView];
        [self addConstraints:verticalConstraintsForContentView];
        
        NSArray *verticalConstraintsForSegmentedControl = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_segmentedControl]|" options:0 metrics:nil views:bindings];
        NSArray *horizontalConstraintsForSegmentedControl = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_segmentedControl]|" options:0 metrics:nil views:bindings];

        //TODO: Center IF the segmentedControl is smaller than the width of the UIScreen...

        [self.contentView addConstraints:verticalConstraintsForSegmentedControl];
        [self.contentView addConstraints:horizontalConstraintsForSegmentedControl
         ];


        self.alreadyUpdatedConstraints = YES;
    }

    [super updateConstraints];
}

-(void)layoutSubviews {

    [super layoutSubviews];

    CGFloat leftInset = (CGRectGetWidth(self.bounds) - CGRectGetWidth(self.contentView.bounds)) / 2.0;

    if (leftInset > 0) {
        self.contentInset = UIEdgeInsetsMake(0, leftInset, 0, 0);
    }

    [super layoutSubviews];
}


#pragma mark - Actions

- (void)didChangeSegmentSelection:(NSUInteger)segmentIndex {
        [self.segmentedControl adjustIndicatorForScroll:self];
}


@end

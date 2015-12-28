//
//  LEOChildSelectorView.m
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

@end

@implementation LEOPatientSelectorView

static const CGFloat kSelectorViewHeight = 32.0;

- (instancetype)initWithPatients:(NSArray *)patients {

    self = [super init];

    if (self) {
        _patients = patients;

        [self.segmentedControl addTarget:self action:@selector(didChangeSegmentSelection:) forControlEvents:UIControlEventValueChanged];
    }

    return self;
}


- (GNZSegmentedControl *)segmentedControl {

    if (!_segmentedControl) {

        NSUInteger segmentCount = [self.patients count];

        GNZSegmentedControl *strongSegmentedControl = [[GNZSegmentedControl alloc] initWithSegmentCount:segmentCount indicatorStyle:GNZIndicatorStyleCustom options:@{GNZSegmentOptionControlBackgroundColor: [UIColor leo_white], GNZSegmentOptionDefaultSegmentTintColor: [[UIColor leo_white] colorWithAlphaComponent:0.5], GNZSegmentOptionSelectedSegmentTintColor: [[UIColor leo_white] colorWithAlphaComponent:1.0], GNZSegmentOptionIndicatorColor: [UIColor leo_white]}];

        strongSegmentedControl.translatesAutoresizingMaskIntoConstraints = NO;

        _segmentedControl = strongSegmentedControl;
        _segmentedControl.backgroundColor = [UIColor clearColor];
        _segmentedControl.font = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont];
        _segmentedControl.controlHeight = 32.0;

        _segmentedControl.customIndicatorAnimatorBlock = ^void(UIScrollView *scrollView) {

            CGFloat leftEdgeOfScrollViewForSegment = [_segmentedControl selectedSegmentIndex]/_segmentedControl.numberOfSegments * CGRectGetWidth(scrollView.frame);
            CGFloat rightEdgeOfScrollViewForSegment = ([_segmentedControl selectedSegmentIndex] + 1)/_segmentedControl.numberOfSegments * CGRectGetWidth(scrollView.frame);

            CGRect selectedSegmentRect = [self.segmentedControl selectedSegmentFrameAdjustedForSpacing];


            self.contentOffset = percentCompleteSegmentViewTransition * CGRectGetWidth(selectedSegmentRect);



//            
//
//
//            CGFloat percentOfSegmentOnToBeOnScreen;
//
//            if (scrollView.contentOffset.x > rightEdgeOfScrollViewForSegment) {
//                percentOfSegmentOnToBeOnScreen = (scrollView.contentOffset.x - leftEdgeOfScrollViewForSegment) / scrollView.contentOffset.x;
//            }
//
//
//            CGRect animationRect = selectedSegmentRect;
//            animationRect.origin.x =
//
//            self.contentOffset = 
////            [self scrollRectToVisible:animationRect animated:YES];
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

    if (CGRectGetWidth(self.segmentedControl.bounds) < CGRectGetWidth(self.bounds)) {

        NSLayoutConstraint *centerXConstraintForContentView = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];

        [self addConstraint:centerXConstraintForContentView];
    }

    [super updateConstraints];
}

- (NSArray *)createPatientButtons {

    NSMutableArray<UIButton *> *patientButtons = [NSMutableArray new];

    for (Patient *patient in self.patients) {

        UIButton *patientButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [patientButton setTitle:patient.firstName forState:UIControlStateNormal];

        [patientButton sizeToFit];

        [patientButtons addObject:patientButton];
        //TODO: Add actions for state to actually move page view control
    }

    return patientButtons;
}


#pragma mark - Actions

- (void)didChangeSegmentSelection:(id)sender {

    CGRect selectedSegmentRect = [self.segmentedControl selectedSegmentFrameAdjustedForSpacing];
    [self scrollRectToVisible:selectedSegmentRect animated:YES];
}


@end

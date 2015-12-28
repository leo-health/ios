//
//  LEOChildHeaderView.m
//  Leo
//
//  Created by Zachary Drossman on 12/27/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOPatientProfileView.h"
#import "Patient.h"
@interface LEOPatientProfileView ()

@property (strong, nonatomic) Patient *patient;

@end

@implementation LEOPatientProfileView

- (instancetype)initWithPatient:(Patient *)patient {
    self = [super init];
    if (self) {
        _patient = patient;
    }
    return self;
}

-(CGSize)intrinsicContentSize {

    return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 150);
}

//- (void)connectSegmentedControl {
//    if (_feedSelectorControl != [self.dataSource segmentedControlForSlidingSegmentView:self]) {
//        _feedSelectorControl = [self.dataSource segmentedControlForSlidingSegmentView:self];
//        [(id)_feedSelectorControl addTarget:self action:@selector(segmentSelectionDidChange:) forControlEvents:UIControlEventValueChanged];
//        self.scrollView.delegate = self;
//    }
//}
@end

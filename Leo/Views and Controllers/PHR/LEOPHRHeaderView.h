//
//  LEOPHRHeaderView.h
//  Leo
//
//  Created by Zachary Drossman on 12/28/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

@class GNZSegmentedControl;

#import <UIKit/UIKit.h>

@interface LEOPHRHeaderView : UIView

@property (strong, nonatomic) GNZSegmentedControl *segmentControl;

- (instancetype)initWithPatients:(NSArray *)patients;
//- (void)didChangeSegmentSelection:(NSUInteger)segmentIndex;

@end

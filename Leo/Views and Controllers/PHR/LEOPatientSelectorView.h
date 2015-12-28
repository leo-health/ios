//
//  LEOChildSelectorView.h
//  Leo
//
//  Created by Zachary Drossman on 12/27/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

@class GNZSegmentedControl;

#import <UIKit/UIKit.h>

@interface LEOPatientSelectorView : UIScrollView

- (instancetype)initWithPatients:(NSArray *)patients;
- (GNZSegmentedControl *)segmentedControl;
- (void)didChangeSegmentSelection:(id)sender;

@end

//
//  LEOPHRHeaderView.h
//  Leo
//
//  Created by Zachary Drossman on 12/28/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

@class GNZSegmentedControl;

#import <UIKit/UIKit.h>
#import "LEONavigateToEditPatient.h"

@interface LEOPHRHeaderView : UIView

@property (nonatomic) NSInteger selectedSegment;
@property (copy, nonatomic) DefaultVoidBlock segmentDidChangeBlock;
@property (weak, nonatomic) id  <LEONavigateToEditPatient> delegate;

- (instancetype)initWithPatients:(NSArray *)patients;

@end

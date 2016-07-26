//
//  LEODraggableLineContainer.h
//  Leo
//
//  Created by Annie Graham on 7/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TelerikUI/TelerikUI.h>

@interface LEODraggableLineContainerView : UIView

@property (strong, nonatomic) NSMutableArray *centerXValuesOfPointsOnGraph;
@property (strong, nonatomic) TKChart *chart;
@property (strong, nonatomic) NSLayoutConstraint *lineXPositionConstraint;

- (void)initGestureRecognizers;


@end
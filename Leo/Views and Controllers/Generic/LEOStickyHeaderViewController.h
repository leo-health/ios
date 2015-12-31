//
//  LEOStickyHeaderViewController.h
//  Leo
//
//  Created by Zachary Drossman on 11/23/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "LEOCard.h"
#import "LEOStickyHeaderView.h"


@interface LEOStickyHeaderViewController : UIViewController

@property (nonatomic) Feature feature;

@property (strong, nonatomic, readonly) LEOStickyHeaderView *stickyHeaderView;

@property (nonatomic, getter=isCollapsable) BOOL collapsable;
@property (nonatomic, readonly, getter=isCollapsed) BOOL collapsed;
@property (nonatomic, readonly) CGPoint scrollViewContentOffset;

-(instancetype)initWithFeature:(Feature)feature collapsable:(BOOL)collapsable collapsedHeight:(CGFloat)collapsedHeight;

-(void)addAnimationToNavBar:(void(^)())animations;
-(CGFloat)transitionPercentageForScrollOffset:(CGPoint)offset;

@end

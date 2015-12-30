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

@property (strong, nonatomic) LEOStickyHeaderView *stickyHeaderView;

@property (nonatomic, getter=isCollapsable) BOOL collapsable;
@property (nonatomic, getter=isCollapsed) BOOL collapsed;
@property (nonatomic) CGPoint scrollViewContentOffset;

-(void)addAnimationToNavBar:(void(^)())animations;
-(CGFloat)transitionPercentageForScrollOffset:(CGPoint)offset;

@end

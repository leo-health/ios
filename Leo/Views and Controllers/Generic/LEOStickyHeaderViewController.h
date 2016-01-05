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


@interface LEOStickyHeaderViewController : UIViewController {
    // used to allow subclasses to override accessors for lazy instantiation
    // source: http://stackoverflow.com/questions/10943042/subclass-of-class-with-synthesized-readonly-property-cannot-access-instance-vari
    @protected
    LEOStickyHeaderView *_stickyHeaderView;
}

@property (nonatomic) Feature feature;

@property (strong, nonatomic, readonly) LEOStickyHeaderView *stickyHeaderView;

@property (nonatomic, getter=isCollapsible) BOOL collapsible;
@property (nonatomic, readonly, getter=isCollapsed) BOOL collapsed;
@property (nonatomic, readonly) CGPoint scrollViewContentOffset;

-(instancetype)initWithFeature:(Feature)feature;

-(void)addAnimationToNavBar:(void(^)())animations;
-(CGFloat)transitionPercentageForScrollOffset:(CGPoint)offset;

@end

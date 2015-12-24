//
//  LEOGradientView.h
//  Leo
//
//  Created by Adam Fanslau on 12/22/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOGradientView : UIView

// gradient animation
@property (strong, nonatomic) NSArray *colors;
@property (nonatomic) CGPoint initialStartPoint;
@property (nonatomic) CGPoint initialEndPoint;
@property (nonatomic) CGPoint finalStartPoint;
@property (nonatomic) CGPoint finalEndPoint;
@property (nonatomic, readonly) CGRect gradientLayerBounds;
@property (nonatomic) CGFloat currentTransitionPercentage;

// title label
@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) UIColor *titleTextColor;
@property (strong, nonatomic) UIFont *titleTextFont;

- (void)resetDefaultStylingForTitleLabel;

@end

//
//  LEOGradientView.h
//  Leo
//
//  Created by Adam Fanslau on 12/22/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOGradientView : UIView

@property (nonatomic, readonly) CGRect gradientLayerBounds;

// gradient animation parameters
@property (strong, nonatomic) NSArray *colors;
@property (nonatomic) CGPoint initialStartPoint;
@property (nonatomic) CGPoint initialEndPoint;
@property (nonatomic) CGPoint finalStartPoint;
@property (nonatomic) CGPoint finalEndPoint;

@property (nonatomic) CGFloat currentTransitionPercentage;

// title label
@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) UIColor *titleTextColor;
@property (strong, nonatomic) UIFont *titleTextFont;

-(instancetype)initWithColors:(NSArray *)colors initialStartPoint:(CGPoint)initialStartPoint initialEndPoint:(CGPoint)initialEndPoint finalStartPoint:(CGPoint)finalStartPoint finalEndPoint:(CGPoint)finalEndPoint;

-(void)resetDefaultStylingForTitleLabel;

@end

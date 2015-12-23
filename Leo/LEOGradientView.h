//
//  LEOGradientView.h
//  Leo
//
//  Created by Adam Fanslau on 12/22/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOGradientView : UIView

@property (nonatomic) CGFloat currentTransitionPercentage;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) UILabel* expandedTitleLabel;
@property (strong, nonatomic) NSArray* colors;
@property (nonatomic) CGPoint initialStartPoint;
@property (nonatomic) CGPoint initialEndPoint;
@property (nonatomic) CGPoint finalStartPoint;
@property (nonatomic) CGPoint finalEndPoint;

@end

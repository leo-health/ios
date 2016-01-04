//
//  LEOGradientHelper.m
//  Leo
//
//  Created by Adam Fanslau on 1/4/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOGradientHelper.h"

@implementation LEOGradientHelper


+(CGFloat)translateRelativePosition:(CGFloat)relativePositionInitial fromSize:(CGFloat)initialSize toSize:(CGFloat)finalSize {

    // get absolute position
    CGFloat absolutePosI = relativePositionInitial * initialSize;
    // get extra size
    CGFloat extra = initialSize - finalSize;
    // subtract extra size
    CGFloat absolutePosF = absolutePosI - extra;
    // get relative position
    CGFloat relPos = absolutePosF / finalSize;

    return relPos;
}

/**
 *  Calculates the start and end points based on a center, rotation and radius
 *  Returns both start and end points by passing the points by reference
 *
 *  @param startPoint a pointer to a CGPoint
 *  @param endPoint   a pointer to a CGPoint
 *  @param center     CGPoint representing the center of the circle
 *  @param r          radius
 *  @param theta      clockwise rotation in radians relative to x axis
 */
+(void)gradientStartPoint:(CGPoint*)startPoint endPoint:(CGPoint*)endPoint withCenter:(CGPoint)center withRadius:(CGFloat)r withRotationInRadians:(CGFloat)theta {

    CGFloat dy = r * sinf(theta);
    CGFloat dx = r * cosf(theta);
    *startPoint = CGPointMake(center.x - dx, center.y - dy);
    *endPoint = CGPointMake(center.x + dx, center.y + dy);
}


@end

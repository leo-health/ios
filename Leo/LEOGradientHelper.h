//
//  LEOGradientHelper.h
//  Leo
//
//  Created by Adam Fanslau on 1/4/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOGradientHelper : NSObject

+(CGFloat)translateRelativePosition:(CGFloat)relativePositionInitial fromSize:(CGFloat)initialSize toSize:(CGFloat)finalSize;
+(void)gradientStartPoint:(CGPoint*)startPoint endPoint:(CGPoint*)endPoint withCenter:(CGPoint)center withRadius:(CGFloat)r withRotationInRadians:(CGFloat)theta;

@end

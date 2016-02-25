//
//  LEOGradientView.h
//  Leo
//
//  Created by Adam Fanslau on 12/22/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOGradientHelper.h"
#import "LEOHeaderView.h"

@interface LEOGradientView : LEOHeaderView

@property (nonatomic, readonly) CGRect gradientLayerBounds;

NS_ASSUME_NONNULL_BEGIN

@property (strong, nonatomic) NSArray *colors;
@property (nonatomic) CGPoint initialStartPoint;
@property (nonatomic) CGPoint initialEndPoint;
@property (nonatomic) CGPoint finalStartPoint;
@property (nonatomic) CGPoint finalEndPoint;

-(instancetype)initWithColors:(NSArray *)colors initialStartPoint:(CGPoint)initialStartPoint initialEndPoint:(CGPoint)initialEndPoint finalStartPoint:(CGPoint)finalStartPoint finalEndPoint:(CGPoint)finalEndPoint titleText:(NSString*)titleText;

NS_ASSUME_NONNULL_END

@end

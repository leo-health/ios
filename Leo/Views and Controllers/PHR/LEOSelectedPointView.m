//
//  LEOSelectedPointView.m
//  Leo
//
//  Created by Zachary Drossman on 4/14/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOSelectedPointView.h"
#import "UIColor+LeoColors.h"

@interface LEOSelectedPointView ()

@property (strong, nonatomic) CAShapeLayer *shapeLayer;

@end

@implementation LEOSelectedPointView


- (instancetype)init {

    self = [super init];

    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)updateConstraints {

    [self setup];

    [super updateConstraints];
}

- (void)setup {

    [self.shapeLayer removeFromSuperlayer];

    self.shapeLayer = [CAShapeLayer new];

    self.shapeLayer.path = [self createBezierPath].CGPath;

    self.shapeLayer.strokeColor = [UIColor leo_orangeRed].CGColor;
    self.shapeLayer.fillColor = [UIColor leo_orangeRed].CGColor;
    self.shapeLayer.lineWidth = 3.0;
    self.shapeLayer.position = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    [self.layer addSublayer:self.shapeLayer];
}

- (UIBezierPath *)createBezierPath {
   return [UIBezierPath bezierPathWithOvalInRect:self.frame];
}


@end

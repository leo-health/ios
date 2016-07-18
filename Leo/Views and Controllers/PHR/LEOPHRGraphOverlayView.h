//
//  LEOPHRGraphOverlayView.h
//  Leo
//
//  Created by Zachary Drossman on 4/8/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEOPHRGraphOverlayView : UIView

@property (nonatomic) CGPoint pointForCentering;

- (instancetype)initWithDate:(NSDate *)date vitalWithUnits:(NSString *)vitalWithUnits vitalType:(NSString *)vitalType percentile:(NSNumber *)percentile;

@end

//
//  LEOChartTimeFrameView.h
//  Leo
//
//  Created by Zachary Drossman on 6/27/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^TimeFrameBlock) (NSInteger startOfRangeInYearsInclusive, NSInteger endOfRangeInYearsExclusive);

typedef NS_ENUM(NSInteger, LEOAgeRange) {

    LEOAgeRangeAll,
    LEOAgeRangeZeroToTwo,
    LEOAgeRangeTwoToFive,
    LEOAgeRangeFivePlus
};

@interface LEOChartTimeFrameView : UIView

@property (nonatomic) LEOAgeRange selectedAgeRange;

- (instancetype)initWithAgeOfChild:(CGFloat)ageOfChild
              timeFrameActionBlock:(TimeFrameBlock)timeFrameBlock;

@end
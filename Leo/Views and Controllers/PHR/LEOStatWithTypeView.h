//
//  LEOStandardStatView.h
//  Leo
//
//  Created by Zachary Drossman on 7/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LEOStatFormat) {
    LEOStatFormatSingleValue,
    LEOStatFormatDoubleValue
};

@interface LEOStatWithTypeView : UIView

- (instancetype)initWithPreformattedString:(NSString *)preformattedString
                                      type:(NSString *)type;

- (instancetype)initWithValues:(NSArray *)values
                         units:(NSArray *)units
                          type:(NSString *)type;

@end

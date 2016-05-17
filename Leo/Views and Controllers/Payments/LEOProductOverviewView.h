//
//  LEOProductOverviewView.h
//  Leo
//
//  Created by Zachary Drossman on 5/16/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEOProductOverviewView : UIView

- (instancetype)initWithFeature:(Feature)feature
                          price:(NSNumber *)price
firstPriceDetailAttributedString:(NSAttributedString *)firstPriceDetailAttributedString
secondPriceDetailAttributedString:(NSAttributedString *)secondPriceDetailAttributedString
    continueTappedUpInsideBlock:(void (^) (void))continueTappedUpInsideBlock;

- (instancetype)initWithFeature:(Feature)feature
                          price:(NSNumber *)price
         firstPriceDetailString:(NSString *)firstPriceDetailString
        secondPriceDetailString:(NSString *)secondPriceDetailString
    continueTappedUpInsideBlock:(void (^) (void))continueTappedUpInsideBlock;

@end

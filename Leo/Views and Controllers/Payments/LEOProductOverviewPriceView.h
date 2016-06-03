//
//  LEOPaymentOverviewPriceView.h
//  Leo
//
//  Created by Zachary Drossman on 5/17/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEOProductOverviewPriceView : UIView

- (instancetype)initWithPrice:(NSNumber *)price firstDetailAttributedString:(NSAttributedString *)firstDetailAttributedString secondDetailAttributedString:(NSAttributedString *)secondDetailAttributedString;

- (instancetype)initWithPrice:(NSNumber *)price firstDetailString:(NSString *)firstDetailString secondDetailString:(NSString *)secondDetailString;

@end

//
//  LEOTwoPartStatView.h
//  Leo
//
//  Created by Zachary Drossman on 7/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEOTwoPartStatView : UIView

@property (copy, nonatomic) NSNumber *primaryValue;
@property (copy, nonatomic) NSString *primaryUnit;
@property (copy, nonatomic) NSNumber *secondaryValue;
@property (copy, nonatomic) NSString *secondaryUnit;


@end

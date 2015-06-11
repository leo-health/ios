//
//  LEOCardView.h
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOSecondaryUserView.h"
#import "LEOConstants.h"

@class LEOCollapsedCard;

@interface LEOCardView : UIView

@property (strong, nonatomic) LEOCollapsedCard *card;


@property (nonatomic) BOOL constraintsAlreadyUpdated;

- (void)setupSubviews;

@end

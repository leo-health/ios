//
//  LEOFeedCellButtonView.h
//  Leo
//
//  Created by Zachary Drossman on 2/17/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOCardProtocol.h"

@interface LEOFeedCellButtonView : UIView

@property (weak, nonatomic) id<LEOCardProtocol> card;

-(instancetype)initWithCard:(id<LEOCardProtocol>)card;

@end

//
//  LEOExpandedCardViewDelegate.h
//  Leo
//
//  Created by Zachary Drossman on 9/8/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class LEOCard;

#import <Foundation/Foundation.h>
#import "LEOCardProtocol.h"

@protocol LEOExpandedCardViewDelegate <NSObject>
NS_ASSUME_NONNULL_BEGIN

- (void)takeResponsibilityForCard:(id<LEOCardProtocol>)card;

NS_ASSUME_NONNULL_END
@end

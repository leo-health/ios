//
//  ExpandedCardViewDelegate.h
//  Leo
//
//  Created by Zachary Drossman on 9/8/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ExpandedCardViewProtocol <NSObject>
NS_ASSUME_NONNULL_BEGIN

- (void)takeResponsibilityForCard:(LEOCard *)card;

NS_ASSUME_NONNULL_END
@end

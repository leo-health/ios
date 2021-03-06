//
//  TimeCollectionController.h
//  LEOCalendar
//
//  Created by Zachary Drossman on 7/29/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Slot;

@protocol TimeCollectionProtocol <NSObject>
NS_ASSUME_NONNULL_BEGIN

- (void)didSelectSlot:(Slot *)slot;

NS_ASSUME_NONNULL_END
@end

@interface TimeCollectionController : NSObject <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>
NS_ASSUME_NONNULL_BEGIN

@property (weak, nonatomic) id<TimeCollectionProtocol>delegate;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView slots:(NSArray *)slots chosenSlot:(nullable Slot *)chosenSlot;
- (BOOL)shouldShowEmptyState; // empty state should really be handled by the collectionViewController, but this whole thing needs to be refactored anyway

NS_ASSUME_NONNULL_END
@end

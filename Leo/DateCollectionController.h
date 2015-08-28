//
//  DateCollectionController.h
//  LEOCalendar
//
//  Created by Zachary Drossman on 7/29/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol DateCollectionProtocol <NSObject>
NS_ASSUME_NONNULL_BEGIN

- (void)didScrollDateCollectionViewToDate:(NSDate *)date selectable:(BOOL)selectable;

@end

@interface DateCollectionController : NSObject <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView dates:(NSDictionary *)slotsDictionary chosenDate:(NSDate *)chosenDate;

- (CGPoint) offsetForWeekOfStartingDate;

@property (weak, nonatomic) id<DateCollectionProtocol>delegate;

NS_ASSUME_NONNULL_END
@end

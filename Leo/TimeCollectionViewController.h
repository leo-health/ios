//
//  TimeCollectionViewController.h
//  Leo
//
//  Created by Zachary Drossman on 6/4/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeSelectionProtocol <NSObject>

- (void)didUpdateAppointmentDateTime:(NSDate *)dateTime;

@end

@interface TimeCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSDate *selectedDate;
@property (weak, nonatomic) id<TimeSelectionProtocol> delegate;

@end

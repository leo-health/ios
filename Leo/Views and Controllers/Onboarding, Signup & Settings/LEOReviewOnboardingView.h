//
//  LEOReviewOnboardingView.h
//  Leo
//
//  Created by Zachary Drossman on 1/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

@class Family, LEOIntrinsicSizeTableView, LEOReviewOnboardingViewController;

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TableViewSection) {

    TableViewSectionGuardians,
    TableViewSectionPatients,
    TableViewSectionButton,
    TableViewSectionCount
};

@interface LEOReviewOnboardingView : UIView <UITableViewDataSource>

@property (weak, nonatomic) LEOIntrinsicSizeTableView *tableView;
@property (weak, nonatomic) LEOReviewOnboardingViewController *controller;
@property (strong, nonatomic) Family *family;

@end

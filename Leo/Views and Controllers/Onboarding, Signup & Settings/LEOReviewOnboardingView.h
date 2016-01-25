//
//  LEOReviewOnboardingView.h
//  Leo
//
//  Created by Zachary Drossman on 1/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

@class Family, LEOIntrinsicSizeTableView;

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TableViewSection) {

    TableViewSectionGuardians = 1,
    TableViewSectionPatients = 2,
    TableViewSectionButton = 3,

    //Keep last as a dynamic way to cover section number
    TableViewNumberOfSections
};

@interface LEOReviewOnboardingView : UIView <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet LEOIntrinsicSizeTableView *tableView;
@property (strong, nonatomic) Family *family;

@end

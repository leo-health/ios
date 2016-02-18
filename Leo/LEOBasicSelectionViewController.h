//
//  LEOBasicSelectionViewController.h
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/3/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOAPIOperation.h"
#import "SingleSelectionProtocol.h"

typedef BOOL (^ConfigureCellBlock)(id cell, id data);
typedef void (^SelectionCriteriaBlock)(BOOL selected, NSIndexPath *indexPath, UITableViewCell *cell);
typedef void (^TableViewNotificationBlock)(NSIndexPath *indexPath, id item, UITableView *tableView);

@interface LEOBasicSelectionViewController : UIViewController <UITableViewDelegate>

@property (copy, nonatomic) NSString *key;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *reuseIdentifier;
@property (copy, nonatomic) ConfigureCellBlock configureCellBlock;
@property (copy, nonatomic) TableViewNotificationBlock notificationBlock;
@property (strong, nonatomic) LEOAPIOperation *requestOperation;
@property (weak, nonatomic) id<SingleSelectionProtocol>delegate;
@property (nonatomic) Feature feature;


@end

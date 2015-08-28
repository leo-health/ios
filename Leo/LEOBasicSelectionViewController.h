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
typedef void (^SelectionCriteriaBlock)(BOOL selected, NSIndexPath *indexPath);

@interface LEOBasicSelectionViewController : UIViewController <UITableViewDelegate>

@property (copy, nonatomic) NSString *key;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *reuseIdentifier;
@property (copy, nonatomic) ConfigureCellBlock configureCellBlock;
@property (strong, nonatomic) LEOAPIOperation *requestOperation;
@property (weak, nonatomic) id<SingleSelectionProtocol>delegate;
@property (strong, nonatomic) UIColor *tintColor;

@end

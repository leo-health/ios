//
//  LEOManagePatientsView.h
//  Leo
//
//  Created by Zachary Drossman on 9/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEOManagePatientsView : UIView

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger cellCount;

-(instancetype)initWithCellCount:(NSInteger)cellCount;

@end

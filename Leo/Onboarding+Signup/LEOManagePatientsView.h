//
//  LEOManagePatientsView.h
//  Leo
//
//  Created by Zachary Drossman on 9/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class LEOIntrinsicSizeTableView;

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TableViewSection) {
    TableViewSectionPatients = 0,
    TableViewSectionAddPatient = 1,
    TableViewSectionButton = 2,

    //keep as last item in enum to provide dynamic number of sections
    TableViewNumberOfSections
};

@interface LEOManagePatientsView : UIView <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet LEOIntrinsicSizeTableView *tableView;
@property (strong, nonatomic) NSArray *patients;

-(instancetype)initWithPatients:(NSArray *)patients;

@end

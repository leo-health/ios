//
//  LEOManagePatientsView.m
//  Leo
//
//  Created by Zachary Drossman on 9/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOManagePatientsView.h"
#import "UIView+Extensions.h"

@interface LEOManagePatientsView ()


@end

@implementation LEOManagePatientsView

#pragma mark - Initialization and Helpers

-(instancetype)initWithPatients:(NSArray *)patients {
    
    self = [super init];
    
    if (self) {
        
        _patients = patients;

        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setupTouchEventForDismissingKeyboard];
}


-(void)setTableView:(UITableView *)tableView {

    _tableView = tableView;

    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

@end

//
//  LEOManagePatientsView.m
//  Leo
//
//  Created by Zachary Drossman on 9/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOManagePatientsView.h"
#import "UIView+Extensions.h"
#import "LEOPromptFieldCell+ConfigureForCell.h"
#import "LEOButtonCell.h"
#import "LEOIntrinsicSizeTableView.h"



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

-(instancetype)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];

    if (self) {

        [self commonInit];
    }

    return self;
}

- (void)commonInit {

    [self setupTouchEventForDismissingKeyboard];
}


- (void)setTableView:(LEOIntrinsicSizeTableView *)tableView {

    _tableView = tableView;

    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.alwaysBounceVertical = NO;

    [_tableView registerNib:[LEOPromptFieldCell nib]
         forCellReuseIdentifier:kPromptFieldCellReuseIdentifier];
    
    [_tableView registerNib:[LEOButtonCell nib] forCellReuseIdentifier:kButtonCellReuseIdentifier];

    _tableView.dataSource = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return TableViewSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section) {

        case TableViewSectionPatients:
            return [self.patients count];

        case TableViewSectionAddPatient:
            return 1;

        case TableViewSectionButton:
            return 1;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {

        case TableViewSectionPatients: {

            Patient *patient = self.patients[indexPath.row];

            LEOPromptFieldCell *cell = [tableView
                                        dequeueReusableCellWithIdentifier:kPromptFieldCellReuseIdentifier
                                        forIndexPath:indexPath];

            [cell configureForPatient:patient];

            return cell;
        }

        case TableViewSectionAddPatient: {

            LEOPromptFieldCell *cell = [tableView
                                        dequeueReusableCellWithIdentifier:kPromptFieldCellReuseIdentifier
                                        forIndexPath:indexPath];

            [cell configureForNewPatient];

            return cell;
        }

        case TableViewSectionButton: {

            LEOButtonCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:kButtonCellReuseIdentifier];

            [buttonCell.button addTarget:nil action:@selector(continueTapped:) forControlEvents:UIControlEventTouchUpInside];

            return buttonCell;
        }
    }

    return nil;
}


@end

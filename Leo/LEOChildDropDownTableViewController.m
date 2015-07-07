//
//  LEOChildDropDownTableViewController.m
//  Leo
//
//  Created by Zachary Drossman on 6/13/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOChildDropDownTableViewController.h"
#import "LEOChildCell+ConfigureForCell.h"
#import "Appointment.h"
#import "Patient.h"
@interface LEOChildDropDownTableViewController ()



@end

@implementation LEOChildDropDownTableViewController

static NSString *childReuseIdentifier = @"ChildCell";

#pragma mark - View Controller Lifecycle and VCL Helper Methods
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.allowsMultipleSelection = NO; //TODO: We will allow for multiple selection in next round of work.
    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    [self.tableView registerNib:[LEOChildCell nib] forCellReuseIdentifier:childReuseIdentifier];
    
    
    [self reloadDataWithCompletion:^{
        [self.tableView invalidateIntrinsicContentSize]; //FIXME: This isn't actually doing anything. Right now the size of the container view is being set in IB based on three children. This will need to change!
    }];
}

- (void)reloadDataWithCompletion:( void (^) (void))completionBlock {
    
    [self.tableView reloadData];
    completionBlock();
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [self.children count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LEOChildCell *cell = [tableView dequeueReusableCellWithIdentifier:childReuseIdentifier forIndexPath:indexPath];
    
    [cell configureForChild:self.children[indexPath.row]];
    
    User *user = self.children[indexPath.row];
    
    //MARK: Using id here appropriate? Normally would use memory address but cannot do it here for some reason right now (temporary Core Data implementation issue? If so, won't be one soon as we're going to remove given caching discussion.)
    if (user.objectID == self.appointment.patient.objectID) {
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        cell.selected = YES;
    }
    
    return cell;
}


#pragma mark - <UITableViewDelegate>
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = YES;
    self.appointment.patient = self.children[indexPath.row];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.children[indexPath.row] == self.appointment.patient) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        cell.selected = YES;
    }
}

@end

//
//  LEOBasicSelectionViewController.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/3/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOBasicSelectionViewController.h"
#import "ArrayDataSource.h"
#import "LEODataManager.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface LEOBasicSelectionViewController ()

@property (strong, nonatomic) ArrayDataSource *dataSource;
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end

@implementation LEOBasicSelectionViewController


#pragma mark - View Controller Lifecycle
-(void)viewDidLoad {
    

    [super viewDidLoad];
    
    [self setupTableView];
    
    [self setupNavBar];
}

#pragma mark - VCL Helper Methods
- (void)setupNavBar {
    
    UILabel *navBarTitleLabel = [[UILabel alloc] init];
    
    navBarTitleLabel.text = self.titleText;
    navBarTitleLabel.textColor = [UIColor leoWhite];
    navBarTitleLabel.font = [UIFont leoTitleBoldFont];
    
    [navBarTitleLabel sizeToFit];
    
    self.navigationItem.titleView = navBarTitleLabel;
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icon-Cancel"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    self.navigationItem.leftBarButtonItem = barBtnItem;
}

- (void)setupTableView {
    
    
    self.tableView = [[UITableView alloc] init];

    self.tableView.estimatedRowHeight = 65;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.view addSubview:self.tableView];
    
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES]; //TODO: Create separate class to set these up for all use cases with two methods that support showing and hiding our customized HUD.

    [self requestDataWithCompletion:^(id data){

        sleep(1.0); //TODO: Remove once moving away from stubs;
        
        self.data = data;
        
        self.dataSource = [[ArrayDataSource alloc] initWithItems:self.data cellIdentifier:self.reuseIdentifier configureCellBlock:self.configureCellBlock];
        
        self.tableView.dataSource = self.dataSource;
        self.tableView.delegate = self;
        
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        [self.tableView reloadData];
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:self.reuseIdentifier bundle:nil]  forCellReuseIdentifier:self.reuseIdentifier];
}

- (void)requestDataWithCompletion:(void (^) (id data))completionBlock {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    self.requestOperation.requestBlock = ^(id data) {
        completionBlock(data);
    };
    
    [queue addOperation:self.requestOperation];
    
}


#pragma mark - <UITableViewDelegate>
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate didUpdateItem:self.data[indexPath.row] forKey:self.key];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Autolayout Constraints
-(void)updateViewConstraints {
    
    if (!self.alreadyUpdatedConstraints) {
        [self.view removeConstraints:self.view.constraints];
        self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_tableView);
        
        NSArray *horizontalLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:viewDictionary];
        NSArray *verticalLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:viewDictionary];
        
        [self.view addConstraints:horizontalLayoutConstraints];
        [self.view addConstraints:verticalLayoutConstraints];
        
        self.alreadyUpdatedConstraints = YES;
    }
    
    [super updateViewConstraints];
}

@end
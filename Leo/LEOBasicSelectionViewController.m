//
//  LEOBasicSelectionViewController.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/3/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOBasicSelectionViewController.h"
#import "ArrayDataSource.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIImage+Extensions.h"
#import "LEOStyleHelper.h"
#import "NSObject+TableViewAccurateEstimatedCellHeight.h"

@interface LEOBasicSelectionViewController ()

@property (strong, nonatomic) ArrayDataSource *dataSource;
@property (weak, nonatomic) UITableView *tableView;

@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end

@implementation LEOBasicSelectionViewController


#pragma mark - View Controller Lifecycle
- (void)viewDidLoad {

    [super viewDidLoad];

    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavBar];
}

#pragma mark - VCL Helper Methods
- (void)setupNavBar {

    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:self.feature withTitleText:self.titleText dismissal:NO backButton:YES shadow:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [LEOStyleHelper removeNavigationBarShadowLineForViewController:self];
}

- (void)setupTableView {
    
    
    UITableView *strongView = [UITableView new];
    self.tableView = strongView;

    [self.tableView registerNib:[UINib nibWithNibName:self.reuseIdentifier bundle:nil]  forCellReuseIdentifier:self.reuseIdentifier];

    [self.view addSubview:self.tableView];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor = [UIColor leo_grayForPlaceholdersAndLines];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    [Localytics tagScreen:self.titleText];

    //TODO: Do we need to use weakself here?
    [LEOApiReachability startMonitoringForController:self withOfflineBlock:^{
        //TODO: Determine what we want to happen here if anything
    } withOnlineBlock:^{
        [self requestDataAndUpdateView];
    }];
}

- (void)requestDataAndUpdateView {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES]; //TODO: Create separate class to set these up for all use cases with two methods that support showing and hiding our customized HUD.

    __weak typeof(self) weakSelf = self;
    [self requestDataWithCompletion:^(id data, NSError *error){

        __strong typeof(self) strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        
        if (error) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Something went wrong!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay." style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }];
        
            [alertController addAction:okAction];
            
            [strongSelf presentViewController:alertController animated:YES completion:nil];
            
            return;
        }
        
        strongSelf.data = data;
        
        SelectionCriteriaBlock selectionCriteriaBlock = ^(BOOL shouldSelect, NSIndexPath *indexPath, UITableViewCell *cell) {
            
            if (shouldSelect) {
                cell.selected = YES;
            }
        };
        
        strongSelf.dataSource = [[ArrayDataSource alloc] initWithItems:strongSelf.data cellIdentifier:strongSelf.reuseIdentifier configureCellBlock:strongSelf.configureCellBlock selectionCriteriaBlock: selectionCriteriaBlock notificationBlock:strongSelf.notificationBlock];
        
        strongSelf.tableView.dataSource = strongSelf.dataSource;
        strongSelf.tableView.delegate = strongSelf;
        
        [strongSelf.tableView reloadData];
    }];
}

- (void)requestDataWithCompletion:(void (^) (id data, NSError *error))completionBlock {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    self.requestOperation.requestBlock = ^(id data, NSError *error) {
        completionBlock(data, error);
    };
    
    [queue addOperation:self.requestOperation];
}


#pragma mark - <UITableViewDelegate>

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate didUpdateItem:self.data[indexPath.row] forKey:self.key];
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [self leo_tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
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

- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)notificationObservers {

    if (!_notificationObservers) {
        _notificationObservers = [NSMutableArray new];
    }
    return _notificationObservers;
}

- (void)dealloc {

    for (id observer in self.notificationObservers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
}


@end

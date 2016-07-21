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
#import "LEOAlertHelper.h"
#import "LEOAnalytic.h"

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

- (void)viewWillDisappear:(BOOL)animated {
    [LEOStyleHelper removeNavigationBarShadowLineForViewController:self];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [LEOAnalytic tagType:LEOAnalyticTypeScreen
                    name:self.titleText];

    __weak typeof(self) weakSelf = self;

    [LEOApiReachability startMonitoringForController:self
                                    withOfflineBlock:^{

                                        __strong typeof(self) strongSelf = weakSelf;

                                        [LEOAlertHelper alertForViewController:strongSelf
                                                                         title:@"Oops!"
                                                                       message:@"Looks like we have a boo boo or your internet is not working at the moment. Please go back and try again."];

                                    }
                                     withOnlineBlock:nil];

    [self requestDataAndUpdateView];
}

- (void)dealloc {
    [self removeObservers];
}

- (void)removeObservers {
    for (id observer in self.notificationObservers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
}


#pragma mark - VCL Helper Methods

- (void)setupNavBar {
    [LEOStyleHelper styleNavigationBarForViewController:self
                                             forFeature:self.feature
                                          withTitleText:self.titleText
                                              dismissal:NO
                                             backButton:YES
                                                 shadow:YES];
}

- (void)setupTableView {

    UITableView *strongView = [UITableView new];
    self.tableView = strongView;

    [self.tableView registerNib:[UINib nibWithNibName:self.reuseIdentifier bundle:nil]  forCellReuseIdentifier:self.reuseIdentifier];

    [self.view addSubview:self.tableView];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor = [UIColor leo_gray176];
}

- (void)requestDataAndUpdateView {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES]; //TODO: Create separate class to set these up for all use cases with two methods that support showing and hiding our customized HUD.

    __weak typeof(self) weakSelf = self;

    [self requestDataWithCompletion:^(id data, NSError *error){

        __strong typeof(self) strongSelf = weakSelf;

        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];

        if (error) {

            [LEOAlertHelper alertForViewController:strongSelf
                                             error:error
                                       backupTitle:@"Oops!"
                                     backupMessage:@"Looks like we have a boo boo or your internet is not working at the moment. Please try again."
                                           okBlock:^(UIAlertAction *action) {
                                               [self pop];
                                     }];
            return;
        }


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


#pragma mark - Actions

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


#pragma mark - Navigation

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Notifications

- (NSMutableArray *)notificationObservers {

    if (!_notificationObservers) {
        _notificationObservers = [NSMutableArray new];
    }
    return _notificationObservers;
}


@end

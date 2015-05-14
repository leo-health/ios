 //
//  LEOFeedTVC.m
//  Leo
//
//  Created by Zachary Drossman on 5/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOFeedTVC.h"
#import "LEOCardCell.h"
#import "LEOApiClient.h"
#import "User.h"
#import "User+Methods.h"
#import "Role.h"
#import "Role+Methods.h"
#import "LEOCoreDataManager.h"
#import "UserRole.h"
#import "UserRole+Methods.h"

@interface LEOFeedTVC ()

@property (strong, nonatomic) LEOCoreDataManager *coreDataManager;

@end

@implementation LEOFeedTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableViewSetup];
    [self testAPI];
}

- (void)tableViewSetup {
    
    self.tableView.estimatedRowHeight = 180;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)testAPI {
    
    Role *role = [Role insertEntityWithName:@"parent" resourceID:@1 resourceType:@"na" managedObjectContext:self.coreDataManager.managedObjectContext];
    UserRole *userRole = [UserRole insertEntityWithRole:role managedObjectContext:self.coreDataManager.managedObjectContext];
    NSDate *nowDate = [NSDate date];
    
    NSSet *roleSet = [NSSet setWithObject:userRole];
    User *user = [User insertEntityWithFirstName:@"Zach" lastName:@"Drossman" dob:nowDate email:@"zd1@leohealth.com" roles:roleSet managedObjectContext:self.coreDataManager.managedObjectContext];
    user.title = @"Mr.";
    user.practiceID = @1;
    user.middleInitial = @"S";
    user.gender = @"male";
    
    [LEOApiClient createUserWithUser:user password:@"leohealth" withCompletion:^(NSDictionary * __nonnull rawResults) {
        NSLog(@"%@", rawResults);
    }];
    
    [LEOApiClient loginUserWithEmail:user.email password:@"leohealth" completion:^(NSDictionary * __nonnull rawResults) {
        NSLog(@"%@", rawResults);
    }];
}


-(LEOCoreDataManager *)coreDataManager {
    if (!_coreDataManager) {
        _coreDataManager = [LEOCoreDataManager sharedManager];
    }
    
    return _coreDataManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LEOCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardCell" forIndexPath:indexPath];
        
    cell.cardView.layer.borderWidth = 1;
    cell.cardView.layer.borderColor = [UIColor blackColor].CGColor;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

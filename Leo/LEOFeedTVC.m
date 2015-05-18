//
//  LEOFeedTVC.m
//  Leo
//
//  Created by Zachary Drossman on 5/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOFeedTVC.h"

#import <OHHTTPStubs/OHHTTPStubs.h>
#import <NSDate+DateTools.h>

#import "LeoCard.h"
#import "ArrayDataSource.h"
#import "LEOCardCell.h"


#import "LEOConstants.h"
#import "LEOApiClient.h"
#import "LEOCoreDataManager.h"

#import "User+Methods.h"
#import "Role+Methods.h"
#import "UserRole+Methods.h"
#import "Appointment+Methods.h"
#import "Conversation+Methods.h"
#import "Message+Methods.h"

@interface LEOFeedTVC ()

@property (strong, nonatomic) LEOCoreDataManager *coreDataManager;
@property (nonatomic, strong) ArrayDataSource *cardsArrayDataSource;

@end

@implementation LEOFeedTVC

static NSString *const adminTestKey = @""; //FIXME: REMOVE BEFORE SENDING OFF TO PRODUCTION!
static NSString * const CardCellIdentifier = @"CardCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testAPI];
    [self.coreDataManager fetchDataWithCompletion:^{
        [self tableViewSetup];
    }];
    
}

- (void)tableViewSetup {
    
    void (^configureCell)(LEOCardCell*, LEOCard*) = ^(LEOCardCell* cell, LEOCard* cardView) {
        cell.cardView.layer.borderWidth = 1;
        cell.cardView.layer.borderColor = [UIColor blackColor].CGColor;

    };
    
    self.cardsArrayDataSource = [[ArrayDataSource alloc] initWithItems:self.coreDataManager.cards
                                                    cellIdentifier:CardCellIdentifier
                                                configureCellBlock:configureCell];
    
    self.tableView.dataSource = self.cardsArrayDataSource;
    
    self.tableView.estimatedRowHeight = 180;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}



//Not super concerned about this method as it is only temporary. Will ultimately become a part of tests. DYK (did you know): the vast majority of iOS developers don't test (and most of those don't even know how!) These comments are going to have to go once we get more iOS developers...

- (void)testAPI {
    
    Role *role = [Role insertEntityWithName:@"parent" resourceID:@1 resourceType:@"na" managedObjectContext:self.coreDataManager.managedObjectContext];
    UserRole *userRole = [UserRole insertEntityWithRole:role managedObjectContext:self.coreDataManager.managedObjectContext];
    NSDate *nowDate = [NSDate date];
    
    NSSet *roleSet = [NSSet setWithObject:userRole];
    User *parentUser = [User insertEntityWithFirstName:@"Marilyn" lastName:@"Drossman" dob:nowDate email:@"md10@leohealth.com" roles:roleSet familyID:nil managedObjectContext: self.coreDataManager.managedObjectContext];
    parentUser.title = @"Mrs.";
    parentUser.practiceID = @1;
    parentUser.middleInitial = @"";
    parentUser.gender = @"female";
    
    __weak id<OHHTTPStubsDescriptor> parentStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSLog(@"Request");
        return [request.URL.host isEqualToString:APIHost] && [request.URL.path isEqualToString:[NSString stringWithFormat:@"%@/%@",APICommonPath, APIEndpointUser]];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        
        NSString *fixture = fixture = OHPathForFile(@"createParentUserResponse.json", self.class);
        OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        return response;
        
    }];

    
    [self.coreDataManager resetPasswordWithEmail:@"md10@leohealth.com" withCompletion:^(NSDictionary * __nonnull rawResults) {
     NSLog(@"RESET PW:%@", rawResults);
     }];
    
    [self.coreDataManager createUserWithUser:parentUser password:@"leohealth" withCompletion:^(NSDictionary * __nonnull rawResults) {
        NSLog(@"%@", rawResults);
        
        [OHHTTPStubs removeStub:parentStub];
        
        [self.coreDataManager loginUserWithEmail:parentUser.email password:@"leohealth" withCompletion:^(NSDictionary * __nonnull rawResults) {
            NSLog(@"%@", rawResults);
            
            self.coreDataManager.currentUser = parentUser;
            self.coreDataManager.userToken = rawResults[@"data"][@"token"]; //temporary until this is being pulled from the keychain
            
            Role *childRole = [Role insertEntityWithName:@"child" resourceID:@2 resourceType:@"na" managedObjectContext:self.coreDataManager.managedObjectContext];
            UserRole *childUserRole = [UserRole insertEntityWithRole:childRole managedObjectContext:self.coreDataManager.managedObjectContext];
            NSSet *childRoleSet = [NSSet setWithObject:childUserRole];
            
            User *childUser = [User insertEntityWithFirstName:@"Zachary" lastName:@"Drossman" dob:[NSDate date] email:@"zd9@leohealth.com" roles:childRoleSet
                                                     familyID:@([self.coreDataManager.currentUser.familyID integerValue] + 1)
                                         managedObjectContext:self.coreDataManager.managedObjectContext];
            
            __weak id<OHHTTPStubsDescriptor> childStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                NSLog(@"Request");
                return [request.URL.host isEqualToString:APIHost] && [request.URL.path isEqualToString:[NSString stringWithFormat:@"%@/%@",APICommonPath, APIEndpointUser]];
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                
                NSString *fixture = fixture = OHPathForFile(@"createChildUserResponse.json", self.class);
                OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type":@"application/json"}];
                return response;
                
            }];
            
            if (self.coreDataManager.currentUser) {
                [self.coreDataManager createUserWithUser:childUser password:@"leohealth" withCompletion:^(NSDictionary * __nonnull rawResults) {
                    NSLog(@"%@", rawResults);
                    [OHHTTPStubs removeStub:childStub];
                }];
            } else {
                NSLog(@"No current user existed from which to attach this child.");
            }
            
            NSDate *date = [NSDate dateWithYear:2015 month:12 day:13 hour:2 minute:30 second:0];
            
            // NSString *dateOfDay = [NSString stringWithFormat:@"%ld/%ld/%ld",date.month, date.day, date.year];
            // NSString *timeOfDay = [NSString stringWithFormat:@"%ld:%ld", date.hour, date.minute];
            
            Appointment *zachsAppt = [Appointment insertEntityWithDate:date startTime:date duration:@30 appointmentType:@"Standard" patientID:@62 providerID:@2 familyID:@63 managedObjectContext:self.coreDataManager.managedObjectContext];
            
            [self.coreDataManager createAppointmentWithAppointment:zachsAppt withCompletion:^(NSDictionary * __nonnull rawResults) {
                NSLog(@"CREATE APPT: %@", rawResults);
                
                [self.coreDataManager getAppointmentsForFamilyOfCurrentUserWithCompletion:^(NSDictionary * __nonnull rawResults) {
                    NSLog(@"GET APPTS: %@", rawResults);
                }];
            }];
            
            [self.coreDataManager getConversationsForCurrentUserWithCompletion:^(NSDictionary * __nonnull rawResults) {
                NSLog(@"GET CONVERSATIONS: %@", rawResults);
                
                Conversation *zachConversation = [Conversation insertEntityWithFamilyID:@([self.coreDataManager.currentUser.familyID integerValue] + 1) conversationID:rawResults[@"data"][@"conversation"][0][@"id"] managedObjectContext:self.coreDataManager.managedObjectContext];
                
                Message *firstMessage = [Message insertEntityWithBody:@"Hello World!" senderID:self.coreDataManager.currentUser.userID managedObjectContext:self.coreDataManager.managedObjectContext];
                
                [self.coreDataManager createMessage:firstMessage forConversation:zachConversation withCompletion:^ void(NSDictionary * __nonnull rawResults) {
                    
                    NSLog(@"CREATE MESSAGE: %@", rawResults);
                    
                    [self.coreDataManager getMessagesForConversation:zachConversation withCompletion:^ void(NSDictionary * __nonnull rawResults) {
                        NSLog(@"GET MESSAGES: %@", rawResults);
                    }];
                }];
            }];
        }];
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

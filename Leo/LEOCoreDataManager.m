//
//  LEOCoreDataManager.m
//  
//
//  Created by Zachary Drossman on 5/11/15.
//
//

#import "LEOCoreDataManager.h"
#import "LEOAPIClient.h"
#import "LEOConstants.h"
#import "Appointment.h"
#import "Conversation.h"
#import "Message.h"
#import "Role+Methods.h"
#import "UserRole+Methods.h"
#import "User+Methods.h"
#import "Card.h"

#import "UIColor+LeoColors.h"
#import "UIImage+Extensions.h"

@interface LEOCoreDataManager()

@property (nonatomic, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readwrite) NSManagedObjectModel *managedObjectModel;

@end

@implementation LEOCoreDataManager

+ (instancetype)sharedManager
{
    static LEOCoreDataManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

#pragma mark - Communcation stack (for APIs)

-(NSString *)userToken {
    //will eventually pull from the keychain, but for now, will come from some temporarily place or be hard coded as necessary.
    return _userToken;
}


- (void)createUserWithUser:(nonnull User *)user password:(nonnull NSString *)password withCompletion:(void (^)( NSDictionary * __nonnull rawResults))completionBlock {
    
    NSMutableDictionary *userParams = [[User dictionaryFromUser:user] mutableCopy];
    userParams[APIParamUserPassword] = password;
    [LEOApiClient createUserWithParameters:userParams withCompletion:^(NSDictionary *rawResults) {
        NSDictionary *userDictionary = rawResults[@"data"][@"user"]; //TODO: Make sure I want this here and not defined somewhere else.
        user.userID = userDictionary[APIParamUserID];
        user.familyID = userDictionary[APIParamUserFamilyID];
        completionBlock(rawResults);
    }];
}

- (void)loginUserWithEmail:(nonnull NSString *)email password:(nonnull NSString *)password withCompletion:(void (^)(NSDictionary * __nonnull rawResults))completionBlock {
    
    NSDictionary *loginParams = @{APIParamUserEmail:email, APIParamUserPassword:password};
    
    [LEOApiClient loginUserWithParameters:loginParams withCompletion:^(NSDictionary *rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

- (void)resetPasswordWithEmail:(nonnull NSString *)email withCompletion:(void (^)(NSDictionary * __nonnull rawResults))completionBlock {
    
    NSDictionary *resetPasswordParams = @{APIParamUserEmail:email};
    
    [LEOApiClient resetPasswordWithParameters:resetPasswordParams withCompletion:^(NSDictionary *rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
    
}

- (void)createAppointmentWithAppointment:(nonnull Appointment *)appointment withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock {
    NSArray *apptProperties = @[[self userToken], appointment.leoPatientID, appointment.date, appointment.startTime, appointment.duration, appointment.leoProviderID, appointment.practiceID];
    NSArray *apptKeys = @[APIParamApptToken, APIParamPatientID, APIParamApptDate, APIParamApptStartTime, APIParamApptDuration, APIParamProviderID, APIParamPracticeID];
    
    NSDictionary *apptParams = [[NSDictionary alloc] initWithObjects:apptProperties forKeys:apptKeys];
    
    [LEOApiClient createAppointmentWithParameters:apptParams withCompletion:^(NSDictionary *rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

- (void)getAppointmentsForFamilyOfCurrentUserWithCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock {
    NSArray *apptProperties = @[[self userToken]];
    NSArray *apptKeys = @[APIParamApptToken];
    
    NSDictionary *apptParams = [[NSDictionary alloc] initWithObjects:apptProperties forKeys:apptKeys];
    
    [LEOApiClient getAppointmentsForFamilyWithParameters:apptParams withCompletion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

- (void)getConversationsForCurrentUserWithCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock {
    
    NSArray *conversationProperties = @[self.userToken];
    NSArray *conversationKeys = @[APIParamApptToken];
    
    NSDictionary *conversationParams = [[NSDictionary alloc] initWithObjects:conversationProperties forKeys:conversationKeys];
    
    [LEOApiClient getConversationsForFamilyWithParameters:conversationParams withCompletion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}


- (void)createMessage:(Message *)message forConversation:(nonnull Conversation *)conversation withCompletion:(nonnull void (^)(NSDictionary  * __nonnull rawResults))completionBlock {
    
    [conversation addMessagesObject:message];
    
    NSArray *messageProperties = @[self.userToken, message.body, message.senderID];
    NSArray *messageKeys = @[APIParamApptToken, APIParamMessageBody, APIParamMessageSenderID];
    
    NSDictionary *messageParams = [[NSDictionary alloc] initWithObjects:messageProperties forKeys:messageKeys];
    
    [LEOApiClient createMessageForConversation:conversation.conversationID withParameters:messageParams withCompletion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

- (void)getMessagesForConversation:(Conversation *)conversation withCompletion:(nonnull void (^)(NSDictionary  * __nonnull rawResults))completionBlock {

    NSArray *messageProperties = @[self.userToken];
    NSArray *messageKeys = @[APIParamApptToken];
    
    NSDictionary *messageParams = [[NSDictionary alloc] initWithObjects:messageProperties forKeys:messageKeys];
    
    [LEOApiClient getMessagesForConversation:conversation.conversationID withParameters:messageParams withCompletion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}












#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext)
    {
        NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
        if (coordinator)
        {
            _managedObjectContext = [[NSManagedObjectContext alloc] init];
            [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
    }
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (!_managedObjectModel)
    {
        NSURL *modelURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"LEODataModel" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LEODataModel.sqlite"];
        NSError *error = nil;
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (void)fetchDataWithCompletion:(void (^) (void))completionBlock {

    //FIXME: Shouldn't really be pulling users for cards, but it works as a placeholder anyway.
    //NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    //self.cards = [[NSArray alloc] init];
    //NSArray *users = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    Role *childRole = [Role insertEntityWithName:@"child" resourceID:@2 resourceType:@"na" managedObjectContext:self.managedObjectContext];
    UserRole *childUserRole = [UserRole insertEntityWithRole:childRole managedObjectContext:self.managedObjectContext];
    NSSet *childRoleSet = [NSSet setWithObject:childUserRole];
    
    User *childUserOne = [User insertEntityWithFirstName:@"Zachary" lastName:@"Drossman" dob:[NSDate date] email:@"zd9@leohealth.com" roles:childRoleSet
                                             familyID:@([self.currentUser.familyID integerValue] + 1)
                                 managedObjectContext:self.managedObjectContext];
    
    User *childUserTwo = [User insertEntityWithFirstName:@"Rachel" lastName:@"Drossman" dob:[NSDate date] email:@"rd9@leohealth.com" roles:childRoleSet
                                                familyID:@([self.currentUser.familyID integerValue] + 1)
                                    managedObjectContext:self.managedObjectContext];
    
    User *childUserThree = [User insertEntityWithFirstName:@"Tracy" lastName:@"Drossman" dob:[NSDate date] email:@"td9@leohealth.com" roles:childRoleSet
                                                familyID:@([self.currentUser.familyID integerValue] + 1)
                                    managedObjectContext:self.managedObjectContext];

    
    Role *doctorRole = [Role insertEntityWithName:@"doctor" resourceID:@2 resourceType:@"na" managedObjectContext:self.managedObjectContext];
    UserRole *doctorUserRole = [UserRole insertEntityWithRole:doctorRole managedObjectContext:self.managedObjectContext];
    NSSet *doctorRoleSet = [NSSet setWithObject:doctorUserRole];
    
    User *doctorUser = [User insertEntityWithFirstName:@"Om" lastName:@"Lala" dob:[NSDate date] email:@"om10@leohealth.com" roles:doctorRoleSet familyID:nil
                                 managedObjectContext:self.managedObjectContext];
    doctorUser.credentialSuffix = @"MD";
    doctorUser.title = @"Dr.";
    
    Card *cardOne = [[Card alloc] initWithID:@1 state:CardStateNew title:@"Welcome to Leo." body:@"If you have any questions or comments, you can reach us at any time." primaryUser:childUserOne secondaryUser:doctorUser timestamp:[NSDate date] priority:@1 activity:CardActivityConversation];
    
    Card *cardTwo = [[Card alloc] initWithID:@2 state:CardStateNew title:@"Schedule Rachel's First Visit" body:@"Take a tour of the practice and meet with our world class physicians." primaryUser:childUserTwo secondaryUser:doctorUser timestamp:[NSDate date] priority:@2 activity:CardActivityAppointment];
    
    Card *cardThree = [[Card alloc] initWithID:@3 state:CardStateNew title:@"Recent Visit" body:@"Jacob was seen for a sore throat and cough." primaryUser:childUserThree secondaryUser:doctorUser timestamp:[NSDate date] priority:@3 activity:CardActivityVisit];

    Card *cardFour = [[Card alloc] initWithID:@1 state:CardStateNew title:@"Welcome to Leo." body:@"If you have any questions or comments, you can reach us at any time." primaryUser:childUserOne secondaryUser:doctorUser timestamp:[NSDate date] priority:@1 activity:CardActivityConversation];
    
    Card *cardFive = [[Card alloc] initWithID:@2 state:CardStateNew title:@"Schedule Rachel's First Visit" body:@"Take a tour of the practice and meet with our world class physicians." primaryUser:childUserTwo secondaryUser:doctorUser timestamp:[NSDate date] priority:@2 activity:CardActivityAppointment];
    
    Card *cardSix = [[Card alloc] initWithID:@3 state:CardStateNew title:@"Recent Visit" body:@"Jacob was seen for a sore throat and cough." primaryUser:childUserThree secondaryUser:doctorUser timestamp:[NSDate date] priority:@3 activity:CardActivityVisit];
    
    self.cards = @[cardOne, cardTwo, cardThree, cardFour, cardFive, cardSix, cardOne, cardTwo, cardThree, cardFour, cardFive, cardSix];
    
    //FIXME: Safety here
    completionBlock();
    //FIXME: This does nothing useful right now!
//    if ([self.cards count] == 0) {
//        for (NSInteger x = 0; x < 100; x++) {
//            LEOCard *card = [[LEOCard alloc] init];
//            NSLog(@"%@", card);
//        }
//        self.cards = [self.managedObjectContext executeFetchRequest:request error:nil];
//    }
}


@end

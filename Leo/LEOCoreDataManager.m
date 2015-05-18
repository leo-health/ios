//
//  LEOCoreDataManager.m
//  
//
//  Created by Zachary Drossman on 5/11/15.
//
//

#import "LEOCoreDataManager.h"
#import "LEOCard.h"
#import "LEOAPIClient.h"
#import "LEOConstants.h"
#import "Appointment.h"
#import "Conversation.h"
#import "Message.h"
#import "User.h"
#import "Role.h"
#import "UserRole.h"
#import "User+Methods.h"

@interface LEOCoreDataManager()

@property (nonatomic, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readwrite) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSString *userToken;

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
    //will eventually pull from the keychain and if not there will ensure the user is logged out, but for now, will come from some temporarily place or be hard coded as necessary.
    return @"";
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

- (void)loginUserWithEmail:(nonnull NSString *)email password:(nonnull NSString *)password completion:(void (^)(NSDictionary * __nonnull rawResults))completionBlock {
    
    NSDictionary *loginParams = @{APIParamUserEmail:email, APIParamUserPassword:password};
    
    [LEOApiClient loginUserWithParameters:loginParams completion:^(NSDictionary *rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

- (void)createAppointmentWithAppointment:(nonnull Appointment *)appointment withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock {
    NSArray *apptProperties = @[[self userToken], appointment.familyID, appointment.leoPatientID, appointment.date, appointment.startTime, appointment.duration, appointment.leoProviderID];
    NSArray *apptKeys = @[APIParamApptToken, APIParamUserFamilyID, APIParamPatientID, APIParamApptDate, APIParamApptStartTime, APIParamApptDuration, APIParamProviderID];
    
    NSDictionary *apptParams = [[NSDictionary alloc] initWithObjects:apptProperties forKeys:apptKeys];
    
    [LEOApiClient createAppointmentWithParameters:apptParams withCompletion:^(NSDictionary *rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

- (void)getAppointmentsForFamilyOfUser:(nonnull User *)user withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock {
    
    NSArray *apptProperties = @[];
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


- (void)createMessageForConversation:(nonnull Conversation *)conversation withContents:(NSDictionary *)content withCompletion:(nonnull void (^)(NSDictionary  * __nonnull rawResults))completionBlock {
    
    NSArray *conversationProperties = @[conversation];
    NSArray *conversationKeys = @[APIParamConversation];
    
    NSDictionary *conversationParams = [[NSDictionary alloc] initWithObjects:conversationProperties forKeys:conversationKeys];
    
    [LEOApiClient createMessageForConversationWithParameters:conversationParams withCompletion:^(NSDictionary *rawResults) {
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
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    self.cards = [[NSArray alloc] init];
    NSArray *users = [self.managedObjectContext executeFetchRequest:request error:nil];
    self.cards = users;
    
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

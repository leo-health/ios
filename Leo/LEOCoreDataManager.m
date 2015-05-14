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

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (!_persistentStoreCoordinator)
    {
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
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (void)prepopulateData
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LeoCard"];
    
    self.cards = [[NSArray alloc] init];
    self.cards = [self.managedObjectContext executeFetchRequest:request error:nil];

    //FIXME: This does nothing useful right now!
    if ([self.cards count] == 0) {
        for (NSInteger x = 0; x < 100; x++) {
            LEOCard *card = [[LEOCard alloc] init];
            NSLog(@"%@", card);
        }
        
        self.cards = [self.managedObjectContext executeFetchRequest:request error:nil];
    }
}


@end

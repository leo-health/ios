
//
//  AppDelegate.m
//  Leo
//
//  Created by Zachary Drossman on 5/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "AppDelegate.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "LEOFeedTVC.h"
#import "LEOSession.h"
#import "LEODevice.h"
#import "Configuration.h"
#import "NSUserDefaults+Extensions.h"
#import <Localytics/Localytics.h>
#import "LEOUserService.h"
#import "Guardian.h"
#import "LEORouter.h"
#import <NSDate+DateTools.h>

@interface AppDelegate ()


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupGlobalFormatting];

    [self setupRemoteNotificationsForApplication:application];
    [self setupObservers];

    [Configuration resetVendorID];
    [Configuration resetStripeKey];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        [self application:application didReceiveRemoteNotification:launchOptions];
    }

    [Configuration downloadRemoteEnvironmentVariablesIfNeededWithCompletion:^(BOOL success, NSError *error) {

        if (success) {
            [Localytics autoIntegrate:[Configuration localyticsAppID] launchOptions:launchOptions];

            #if defined(INTERNAL) || defined(RUNNABLE)
                [Localytics setLoggingEnabled:YES];
            #endif
        }
    }];

    [LEORouter routeUserWithAppDelegate:self];

    return YES;
}

- (void)setupObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:kNotificationMembershipChanged
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:kNotificationTokenInvalidated
                                               object:nil];
}

- (void)removeObservers {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationMembershipChanged object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationTokenInvalidated object:nil];
}

- (void)dealloc {

    [self removeObservers];
}

- (void)notificationReceived:(NSNotification *)notification {

    if ([notification.name isEqualToString:kNotificationMembershipChanged]) {
        [LEORouter routeUserWithAppDelegate:self];
    }

    if ([notification.name isEqualToString:kNotificationTokenInvalidated]) {
        [LEORouter appDelegate:self setRootViewControllerWithStoryboardName:kStoryboardLogin];
    }
}



- (void)setupRemoteNotificationsForApplication:(UIApplication *)application {

    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [application registerUserNotificationSettings:mySettings];
    [application registerForRemoteNotifications];
}


- (void)setupGlobalFormatting {
    
    self.window.tintColor = [UIColor leo_white];
    NSDictionary *barButtonAppearanceDict = @{NSFontAttributeName : [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont], NSForegroundColorAttributeName: [UIColor leo_white]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonAppearanceDict
                                                forState:UIControlStateNormal];
    [self roundCornersOfWindow];
}

- (void)roundCornersOfWindow {
    
    self.window.layer.cornerRadius = kCornerRadius;
    self.window.layer.masksToBounds = YES;
    self.window.layer.opaque = NO;
    self.window.layer.shouldRasterize = YES;
    self.window.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    // source: http://stackoverflow.com/questions/9647931/nsuserdefaults-synchronize-method
    [NSUserDefaults leo_saveDefaults];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // TODO: remove this when adding feature: use badge on chat mini card
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    if ([LEOSession user]) {
        [[LEOUserService new] getUserWithID:[LEOSession user].objectID withCompletion:^(Guardian *guardian, NSError *error) {

            [LEOSession updateCurrentSessionWithGuardian:guardian];
        }];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    
    // Prepare the Device Token for Registration (remove spaces and < >)
    NSString *deviceTokenString = [[[[deviceToken description]
                                     stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                    stringByReplacingOccurrencesOfString:@">" withString:@""]
                                   stringByReplacingOccurrencesOfString: @" " withString: @""];

    [LEODevice createTokenWithString:deviceTokenString];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"%s..userInfo=%@",__FUNCTION__,userInfo);
    
    UIApplicationState state = [application applicationState];
    
    if (state == UIApplicationStateActive) {
        
        //the app is in the foreground, so here you do your stuff since the OS does not do it for you
        //navigate the "aps" dictionary looking for "loc-args" and "loc-key", for example, or your personal payload)
        
    } else {

        NSURL *pushURL = userInfo[kPushNotificationParamDeepLink];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:pushURL];
        });
    }
    
    application.applicationIconBadgeNumber = 0;
}

- (BOOL)leo_application:(UIApplication * )application openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {

    if ([url.scheme isEqualToString:kDeepLinkDefaultScheme]) {

        if ([LEOSession isLoggedIn]) {

            if ([url.host isEqualToString:kDeepLinkPathFeed]) {

                NSArray *pathComponents = url.pathComponents;

                if (pathComponents.count > 2) {

                    [self feedTVC].cardInFocusType = [LEOCard cardTypeWithString:pathComponents[1]];
                    [self feedTVC].cardInFocusObjectID = pathComponents[2];

                    return YES;
                }
            }
        }
    }

    // explicitly return YES in all valid url structures
    NSLog(@"An unknown action was passed.");
    return NO;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {

    return [self leo_application:application openURL:url options:nil];
}

- (BOOL)application:(UIApplication *) application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options {

    return [self leo_application:application openURL:url options:options];
}

- (LEOFeedTVC *)feedTVC {

    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    if ([nav isKindOfClass:[UINavigationController class]]) {
        return [[nav viewControllers] firstObject];
    }
    return nil;
}


@end

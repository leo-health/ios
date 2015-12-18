
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
#import "SessionUser.h"
#import "DeviceToken.h"

#if STUBS_FLAG
#import "LEOStubs.h"
#endif

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupGlobalFormatting];
    
#if STUBS_FLAG
    [LEOStubs setupStubs];
#endif
    
    [self setupRemoteNotificationsForApplication:application];
    [self setupObservers];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSString *storyboardIdentifier;
    
    if (!launchOptions) {
        
        storyboardIdentifier = [SessionUser isLoggedIn] ? kStoryboardFeed : kStoryboardLogin;
    } else {

        storyboardIdentifier = kStoryboardLogin;
        //TODO: Figure out what other launch option situations we want to account for.
    }
    
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        [self application:application didReceiveRemoteNotification:launchOptions];
    }
    
    [self setRootViewControllerWithStoryboardName:storyboardIdentifier];
    
    SessionUser *user = [[SessionUser alloc] initFromUserDefaults];
    [SessionUser setCurrentUser:user];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setupObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"membership-changed"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"token-invalidated"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification {
    
    if ([notification.name isEqualToString:@"membership-changed"]) {
        
        switch ([SessionUser guardian].membershipType) {
                
            case MembershipTypeMember:
                
                if ([SessionUser isLoggedIn]) {
                    [self setRootViewControllerWithStoryboardName:kStoryboardFeed];
                }
                
                break;
                
            case MembershipTypeUnpaid:
                
            case MembershipTypeIncomplete:
                
                [self setRootViewControllerWithStoryboardName:kStoryboardLogin];
                break;
                
            case MembershipTypeNone:
                break; //We don't use this explicitly to do anything, because token invalidation is more appropriate if this were to happen.
        }
    }
    
    if ([notification.name isEqualToString:@"token-invalidated"]) {
        
        [self setRootViewControllerWithStoryboardName:kStoryboardLogin];
    }
}

- (void)setRootViewControllerWithStoryboardName:(NSString *)storyboardName {
    
    storyboardName = storyboardName ?: kStoryboardLogin;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    
    UIViewController *initialVC = [storyboard instantiateInitialViewController];
    
    if (self.window.rootViewController && [self.window.rootViewController class] != [initialVC class]) {
        
        [UIView transitionFromView:self.window.rootViewController.view
                            toView:initialVC.view
                          duration:0.65f
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:^(BOOL finished){
                            
                            if (finished) {
                                
                                self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                                self.window.rootViewController = [storyboard instantiateInitialViewController];
                                
                                [self.window makeKeyAndVisible];
                            }
                        }];
    } else {
        
        self.window.rootViewController = initialVC;
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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
    
    [DeviceToken createTokenWithString:deviceTokenString];
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
        
        //TODO: This is just a test URL. Will need to make dynamic eventually.
        NSURL *pushURL = [NSURL URLWithString:@"leohealth://feed/0"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:pushURL];
        });
    }
    
    application.applicationIconBadgeNumber = 0;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    if ([url.scheme isEqualToString: @"leohealth"]) {
        
        if ([SessionUser isLoggedIn]) {
            
            if ([url.host isEqualToString: @"feed"]) {
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryboardFeed bundle:nil];
                UINavigationController *navController = [storyboard instantiateInitialViewController];
                LEOFeedTVC *feedTVC = navController.viewControllers[0];
                feedTVC.cardInFocus = [url.path integerValue];
                self.window.rootViewController = navController;
            } else {
                
                NSLog(@"An unknown action was passed.");
            }
        }
    }
    
    else {
        NSLog(@"Not opened by Leo Health.");
    }
    
    return NO;
}

- (BOOL)application: (UIApplication * ) application openURL: (NSURL * ) url options:(nonnull NSDictionary<NSString *,id> *)options {
    
    if ([url.scheme isEqualToString: @"leohealth"]) {
        
        if ([SessionUser isLoggedIn]) {
            
            if ([url.host isEqualToString: @"home"]) {
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryboardFeed bundle:nil];
                
                self.window.rootViewController = [storyboard instantiateInitialViewController];
                
            } else if ([url.host isEqualToString: @"conversation"]) {
                
                [self.window.rootViewController.storyboard instantiateInitialViewController];
            } else {
                
                NSLog(@"An unknown action was passed.");
            }
        }
    } else {
        
        NSLog(@"We were not opened with Leo.");
    }
    
    return NO;
}


@end

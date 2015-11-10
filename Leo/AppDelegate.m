
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
    
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        [self application:application didReceiveRemoteNotification:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
    }
    
    return YES;
}


- (void)setupRemoteNotificationsForApplication:(UIApplication *)application {
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [application registerUserNotificationSettings:mySettings];
    [application registerForRemoteNotifications];
}


- (void)setupGlobalFormatting {
    
    self.window.tintColor = [UIColor leoWhite];
    NSDictionary *barButtonAppearanceDict = @{NSFontAttributeName : [UIFont leoFieldAndUserLabelsAndSecondaryButtonsFont], NSForegroundColorAttributeName: [UIColor leoWhite]};
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


-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    // Prepare the Device Token for Registration (remove spaces and < >)
    NSString *devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"My token is: %@", devToken);
}

-(void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
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
        
        SessionUser *user = [SessionUser currentUser];
        
        if ([user isLoggedIn]) {
        //TODO: We still need to check that the user is logged in first. In fact...that's probably going to be an issue, no?
        
            if ([url.host isEqualToString: @"feed"]) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
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
        NSLog(@"Not opened by LeoHealth.");
    }
    return NO;
}

-(BOOL) application: (UIApplication * ) application openURL: (NSURL * ) url options:(nonnull NSDictionary<NSString *,id> *)options {
    
    if ([url.scheme isEqualToString: @"leohealth"]) {

        //TODO: We still need to check that the user is logged in first. In fact...that's probably going to be an issue, no?
        
        if ([url.host isEqualToString: @"home"]) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            self.window.rootViewController = [storyboard instantiateInitialViewController];
            
        } else if ([url.host isEqualToString: @"conversation"]) {
            [self.window.rootViewController.storyboard instantiateInitialViewController];
        } else {
            NSLog(@"An unknown action was passed.");
        }
    } else {
        NSLog(@"We were not opened with birdland.");
    }
    return NO;
}

@end





































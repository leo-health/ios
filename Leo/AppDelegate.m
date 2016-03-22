
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
#import "LEODevice.h"
#import "Configuration.h"
#import "LEOConstants.h"
#import "LEOStyleHelper.h"
#import "NSUserDefaults+Extensions.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupGlobalFormatting];

    [self setupRemoteNotificationsForApplication:application];
    [self setupObservers];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSString *storyboardIdentifier = [SessionUser isLoggedIn] ? kStoryboardFeed : kStoryboardLogin;
    
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        [self application:application didReceiveRemoteNotification:launchOptions];
    }
    
    [self setRootViewControllerWithStoryboardName:storyboardIdentifier];
    
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

        if ([SessionUser guardian].membershipType != MembershipTypeNone) {
            [self setRootViewControllerWithStoryboardName:kStoryboardFeed];
        }
    }
    
    if ([notification.name isEqualToString:kNotificationTokenInvalidated]) {
        
        [self setRootViewControllerWithStoryboardName:kStoryboardLogin];
    }
}

- (void)setRootViewControllerWithStoryboardName:(NSString *)storyboardName {
    
    storyboardName = storyboardName ?: kStoryboardLogin;

    if ([storyboardName isEqualToString:kStoryboardLogin]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    
    UIViewController *initialVC = [storyboard instantiateInitialViewController];

    [LEOStyleHelper roundCornersForView:initialVC.view withCornerRadius:kCornerRadius];
    
    if (self.window.rootViewController && [self.window.rootViewController class] != [initialVC class]) {

        // transitionFromView should take the view currently visible on screen, or the animation will not happen correctly.

        // TODO: find a more general way of finding the top view controller. Can we travaerse the view hierarchy? Which view is appropriate to use in transitionFromView?
        UIViewController *rootVC = self.window.rootViewController;
        UIViewController *topVC = rootVC;
        if (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        }

        // MARK: IOS8 unfortunately this solves the problem on iOS 8 where the collectionView frame appears as {0,20, 320, 548}. Should be full screen {0,0,320,568}
        NSOperatingSystemVersion osVersion = [[NSProcessInfo processInfo] operatingSystemVersion];
        if (osVersion.majorVersion <= 8) {
            initialVC.view.frame = topVC.view.frame;
        }
        
        [UIView transitionFromView:topVC.view
                            toView:initialVC.view
                          duration:0.65f
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:^(BOOL finished){

                            if (finished) {
                                self.window.rootViewController = initialVC;
                                [self.window makeKeyAndVisible];
                            }
                        }];
    } else {
        
        self.window.rootViewController = initialVC;
        [self.window makeKeyAndVisible];
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

    [Configuration downloadRemoteEnvironmentVariablesIfNeededWithCompletion:^(BOOL success, NSError *error) {
        [Configuration updateCrittercismWithNewKeys];
    }];

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // TODO: remove this when adding feature: use badge on chat mini card
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
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

        if ([SessionUser isLoggedIn]) {

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

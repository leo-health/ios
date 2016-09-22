//
//  LEOAttributedLabelDelegate.m
//  Leo
//
//  Created by Zachary Drossman on 8/9/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOAttributedLabelDelegate.h"
#import <EventKit/EventKit.h>
#import "LEOAlertHelper.h"
#import "LEOFormatting.h"
#import <EventKitUI/EventKitUI.h>
#import "LEOStatusBarNotification.h"

@interface LEOAttributedLabelDelegate()

@property (weak, nonatomic) UIViewController *viewController;
@property (copy, nonatomic) CreateEventBlock createEventBlock;

@end

@implementation LEOAttributedLabelDelegate

- (instancetype)initWithViewController:(UIViewController *)viewController setupEventBlock:(CreateEventBlock)createEventBlock {

    self = [super init];

    if (self) {

        _viewController = viewController;
        _createEventBlock = createEventBlock;
    }

    return self;
}

-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithDate:(NSDate *)date {

    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:nil
                                        message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *addToCalendarAction =
    [UIAlertAction actionWithTitle:@"Add to Calendar"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * _Nonnull action) {
                               [self prepareForAddingToCalendarWithDate:date];
                           }];

    UIAlertAction *cancelAction =
    [UIAlertAction actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                           handler:nil];

    [alertController addAction:addToCalendarAction];
    [alertController addAction:cancelAction];

    [self.viewController presentViewController:alertController
                       animated:YES
                     completion:nil];
};

- (void)prepareForAddingToCalendarWithDate:(NSDate *)date {

    EKEventStore *store = [EKEventStore new];

    BOOL accessible =
    [store respondsToSelector:@selector(requestAccessToEntityType:completion:)];

    if(accessible) {

        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {

            if (granted) {

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadEventControllerWithEventStore:store startDate:date];
                });
            } else {

                dispatch_async(dispatch_get_main_queue(), ^{

                    UIAlertController *permissionController = [LEOAlertHelper alertWithTitle:@"We need your permission"
                                                                                     message:@"Looks like we don't have access to your calendar. Head over to Settings to allow us access."
                                                                                 actionTitle:@"Go To Settings"
                                                                                 actionStyle:UIAlertActionStyleDefault
                                                                                     handler:^(UIAlertAction * _Nonnull action) {

                                                                                         NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                                                         [[UIApplication sharedApplication] openURL:appSettings];
                                                                                     }
                                                                                 cancellable:YES];
                    
                    [self.viewController presentViewController:permissionController animated:YES completion:nil];
                });
            }
        }];
    }
}

- (void)loadEventControllerWithEventStore:(EKEventStore *)eventStore
                                     startDate:(NSDate *)startDate {

    EKEvent *event = self.createEventBlock(eventStore, startDate);

    //FIXME: These next few lines should be in a helper somewhere, potentially worth waiting until after we have discussion re: LEOStyleHelper updates to make changes here.

    [[UIBarButtonItem appearanceWhenContainedIn:[EKEventEditViewController class], nil]
     setTitleTextAttributes: nil
     forState:UIControlStateNormal];

    [[UINavigationBar appearanceWhenContainedIn:[EKEventEditViewController class], nil]
     setBackgroundImage:nil
     forBarPosition:UIBarPositionAny
     barMetrics:UIBarMetricsDefault];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault
                                                animated:YES];

    EKEventEditViewController *eventViewController = [EKEventEditViewController new];
    eventViewController.event = event;
    eventViewController.eventStore = eventStore;
    eventViewController.editViewDelegate = self;

    [self.viewController presentViewController:eventViewController
                       animated:YES
                     completion:nil];
}

-(void)attributedLabel:(TTTAttributedLabel *)label
  didSelectLinkWithURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}

- (void)eventEditViewController:(EKEventEditViewController *)controller
          didCompleteWithAction:(EKEventEditViewAction)action {

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent
                                                animated:YES];
    [self.viewController dismissViewControllerAnimated:YES
                             completion:nil];

    //ZSD - Simple notification of success; may wish to move this into a separate class too at some point for actions that require a local notification; will be even easier in Swift I'm sure.
    if (action == EKEventEditViewActionSaved) {

        LEOStatusBarNotification *savedNotification =
        [[LEOStatusBarNotification alloc] init];

        [savedNotification displayNotificationWithMessage:@"Added to calendar!"
                                              forDuration:1.0f];
    }
}

@end

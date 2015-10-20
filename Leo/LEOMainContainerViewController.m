//
//  LEOMainContainerViewController.m
//  Leo
//
//  Created by Zachary Drossman on 6/23/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOMainContainerViewController.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "UIImage+Extensions.h"
#import <UIImage+Resize.h>
#import "LEOPageViewController.h"
#import "UIImageEffects.h"
#import <VBFPopFlatButton/VBFPopFlatButton.h>
#import "MenuView.h"

#import "Appointment.h"
#import "LEOCardAppointment.h"

@interface LEOMainContainerViewController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@end

@implementation LEOMainContainerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self primaryInterfaceSetup];
    [self setupMenuButton];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    //Set background color such that the status bar color matches the color of the navigation bar.
    self.view.backgroundColor = [UIColor leoOrangeRed];
}


/**
 *  Setup navigation bar with leo heart and individual child navigation.
 */
- (void)primaryInterfaceSetup {
    
    self.navBar.barTintColor = [UIColor leoOrangeRed];
    self.navBar.translucent = NO;
    
    UIImage *heartBBI = [[UIImage imageNamed:@"Icon-LeoHeart"] resizedImageToSize:CGSizeMake(30.0, 30.0)];
    
    UIBarButtonItem *leoheartBBI = [[UIBarButtonItem alloc] initWithImage:heartBBI style:UIBarButtonItemStylePlain target:self action:nil];
    
    UINavigationItem *navCarrier = [[UINavigationItem alloc] init];
    
    navCarrier.leftBarButtonItems = @[leoheartBBI];
    navCarrier.rightBarButtonItems = @[];
//    navCarrier.rightBarButtonItems = [self createBarButtonArrayForNavigationItem];
    
    self.navBar.items = @[navCarrier];
}





@end

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
#import "LEOCardScheduling.h"
#import "LEODataManager.h"

@interface LEOMainContainerViewController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) LEOPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet VBFPopFlatButton *menuButton;

@property (nonatomic) BOOL menuShowing;
@property (strong, nonatomic) UIImageView *blurredImageView;
@property (strong, nonatomic) MenuView *menuView;
@property (strong, nonatomic) LEODataManager *dataManager;

@end

@implementation LEOMainContainerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self primaryInterfaceSetup];
    [self setupMenuButton];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.dataManager = [LEODataManager sharedManager];
    
    //Set background color such that the status bar color matches the color of the navigation bar.
    self.view.backgroundColor = [UIColor leoOrangeRed];
}


/**
 *  Setup navigation bar with leo heart and individual child navigation.
 */
- (void)primaryInterfaceSetup {
    
    self.navBar.barTintColor = [UIColor leoOrangeRed];
    self.navBar.translucent = NO;
    
    UIImage *heartBBI = [[UIImage imageNamed:@"leoheart"] resizedImageToSize:CGSizeMake(30.0, 30.0)];
    
    UIBarButtonItem *leoheartBBI = [[UIBarButtonItem alloc] initWithImage:heartBBI style:UIBarButtonItemStylePlain target:self.pageViewController action:@selector(flipToFeed)];
    
    UINavigationItem *navCarrier = [[UINavigationItem alloc] init];
    
    navCarrier.leftBarButtonItems = @[leoheartBBI];
    navCarrier.rightBarButtonItems = [self createBarButtonArrayForNavigationItem];
    
    self.navBar.items = @[navCarrier];
}

/**
 *  creates UIBarButtonItems out of user's children
 *
 *  @return NSArray of UIBarButtonItems for UINavigationItem
 */
- (NSArray *)createBarButtonArrayForNavigationItem {
    
    /*  Zachary Drossman
     *  BarButtonitems are hard coded for the time-being.
     *  TODO: Must be replaced with alternative implementation that loads from a scrollview or alternative for different number of children.
     */
    
    UIBarButtonItem *childOne = [[UIBarButtonItem alloc] initWithTitle:@"ZACHARY" style:UIBarButtonItemStylePlain target:self.pageViewController action:@selector(flipToChild:)];
    UIBarButtonItem *childTwo = [[UIBarButtonItem alloc] initWithTitle:@"RACHEL" style:UIBarButtonItemStylePlain target:self.pageViewController action:@selector(flipToChild:)];
    UIBarButtonItem *childThree = [[UIBarButtonItem alloc] initWithTitle:@"TRACY" style:UIBarButtonItemStylePlain target:self.pageViewController action:@selector(flipToChild:)];
    
    return @[childThree, childTwo, childOne];
}

/**
 *  Create a blurred version of the current view. Does not blur status bar currently.
 *
 *  @return the blurred UIImage
 */
-(UIImage *)blurredSnapshot {
    
    self.menuButton.hidden = YES;
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, NO, 0);
    
    [self.view drawViewHierarchyInRect:[UIScreen mainScreen].bounds afterScreenUpdates:YES];
    
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIImage *blurredSnapshotImage = [UIImageEffects imageByApplyingBlurToImage:snapshotImage withRadius:4 tintColor:nil saturationDeltaFactor:1.0 maskImage:nil];
    
    UIGraphicsEndImageContext();
    
    self.menuButton.hidden = NO;
    return blurredSnapshotImage;
}


/**
 *  Initialize VBFPopFlatButton for menu with appropriate values for key properties.
 */
- (void)setupMenuButton {
    
    self.menuButton.currentButtonType = buttonAddType;
    self.menuButton.currentButtonStyle = buttonRoundedStyle;
    self.menuButton.tintColor = [UIColor leoWhite];
    self.menuButton.roundBackgroundColor = [UIColor leoOrangeRed];
    self.menuButton.animateToStartPosition = NO;
    self.menuButton.lineThickness = 1;
    [self.menuButton addTarget:self action:@selector(menuTapped) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  Toggle method for blur and menu animation when `menuButton` is tapped.
 */
- (void)menuTapped {
    
    if (!self.menuShowing) {
        [self initializeMenuView];
        [self animateMenuLoad];
    } else {
        
        [self animateMenuDisappearWithCompletion:^{
            [self dismissMenuView];
        }];
    }
    
    self.menuShowing = !self.menuShowing;
}


/**
 *  Load Main Menu for Leo. Includes blurred background and updated menu button.
 */
- (void)animateMenuLoad {
    
    UIImage *blurredView = [self blurredSnapshot];
    self.blurredImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    self.blurredImageView.image = blurredView;
    [self.view insertSubview:self.blurredImageView belowSubview:self.menuView];
    [self.menuButton animateToType:buttonCloseType];
    self.menuButton.roundBackgroundColor = [UIColor clearColor];
    self.menuButton.tintColor = [UIColor leoOrangeRed];
    
    self.blurredImageView.alpha = 0;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.menuView.alpha = 0.8;
        self.blurredImageView.alpha = 1;
        [self.menuButton layoutIfNeeded];
        [self.menuView layoutIfNeeded];
    }];
}


/**
 *  Unload main menu. Includes blurred background and updated menu button.
 */
- (void)animateMenuDisappearWithCompletion:(void (^)(void))completionBlock {
    
    [self.menuButton animateToType:buttonAddType];
    self.menuButton.roundBackgroundColor = [UIColor leoOrangeRed];
    self.menuButton.tintColor = [UIColor leoWhite];
    self.blurredImageView.alpha = 1;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.blurredImageView.alpha = 0;
        self.menuView.alpha = 0;
        [self.menuButton layoutIfNeeded];
        [self.menuView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.blurredImageView removeFromSuperview];
        
        if (completionBlock) {
            completionBlock();
        }
    }];
}


/**
 *  Layout and set initial state of main menu.
 */
- (void)initializeMenuView {
    
    self.menuView = [[MenuView alloc] init];
    self.menuView.alpha = 0;
    self.menuView.translatesAutoresizingMaskIntoConstraints = NO;
    self.menuView.delegate = self;
    
    [self.view insertSubview:self.menuView belowSubview:self.menuButton];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_menuView);
    
    NSArray *horizontalMenuViewLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_menuView]|" options:0 metrics:nil views:viewsDictionary];
    
    NSArray *verticalMenuViewLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_menuView]|" options:0 metrics:nil views:viewsDictionary];
    
    [self.view addConstraints:horizontalMenuViewLayoutConstraints];
    [self.view addConstraints:verticalMenuViewLayoutConstraints];
    [self.view layoutIfNeeded];
}

/**
 *  Remove menu view from superview and clear it from memory.
 */
- (void)dismissMenuView {
    
    [self.menuView removeFromSuperview];
    self.menuView = nil;
}

-(void)didMakeMenuChoice {
    
    [self animateMenuDisappearWithCompletion:^{
        [self.pageViewController flipToFeed];
        [self dismissMenuView];
    }];
}

#pragma mark - Navigation


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"PageViewEmbedSegue"]) {
        self.pageViewController = segue.destinationViewController;
        self.pageViewController.navBar = self.navBar;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end

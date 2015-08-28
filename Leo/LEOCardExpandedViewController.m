//
//  LEOCardExpandedViewController.m
//  Leo
//
//  Created by Zachary Drossman on 7/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOCardExpandedViewController.h"

#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"

@interface LEOCardExpandedViewController ()

@property (strong, nonatomic) UINavigationBar *navBar;
@property (strong, nonatomic) UIView *buttonView;

@property (strong, nonatomic) NSDictionary *viewsDictionary;
@property (nonatomic) BOOL constraintsAlreadyUpdated;

@end

@implementation LEOCardExpandedViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupNavBar];
    [self setupButtonsAsNeeded];
}

- (UIImage *)iconImage {

    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)setupNavBar {
    
    UINavigationItem *navCarrier = [[UINavigationItem alloc] init];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[self iconImage]];
    [iconImageView sizeToFit];

    UIBarButtonItem *icon = [[UIBarButtonItem alloc] initWithCustomView:iconImageView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    titleLabel.text = self.card.title;
    titleLabel.font = [UIFont leoMenuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    titleLabel.textColor = [UIColor leoGrayForTitlesAndHeadings];
    [titleLabel sizeToFit];
    
    UIBarButtonItem *titleBBI = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
    
    
    self.dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    //FIXME: Placeholder image for dismiss image
    [self.dismissButton setImage:[UIImage imageNamed:@"Icon-Cancel"] forState:UIControlStateNormal];
    self.dismissButton.tintColor = [UIColor leoWhite];
    [self.dismissButton sizeToFit];
    
    UIBarButtonItem *dismissBBI = [[UIBarButtonItem alloc] initWithCustomView:self.dismissButton];
    navCarrier.leftBarButtonItems = @[icon, titleBBI];
    navCarrier.rightBarButtonItems = @[dismissBBI];
    
    self.navBar.items = @[navCarrier];
}

- (NSDictionary *)viewsDictionary {
    if (!_viewsDictionary) {
        _viewsDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return _viewsDictionary;
}

/**
 *  Creates buttons for card
 */
- (void)setupButtonsAsNeeded {
    
    for (NSInteger i = 0; i < self.buttonCount; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:NSSelectorFromString([NSString stringWithFormat:@"button%ldTapped",(long)i]) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:self.card.stringRepresentationOfActionsAvailableForState[i] forState:UIControlStateNormal];
        button.backgroundColor = self.card.tintColor;
        [self.buttonView addSubview:button];
        
        [button setTitleColor:[UIColor leoWhite] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont leoButtonLabelsAndTimeStampsFont];

        
        [self.viewsDictionary setValue:button forKey:[NSString stringWithFormat:@"button%ld",(long)i]];
    }
}


/**
 *  Counts buttons on card based on actionsAvailableForState method in LEOCard object
 *
 *  @return NSInteger count of buttons
 */
- (NSInteger)buttonCount {
    return [self.card.actionsAvailableForState count];
}


- (void)dismiss {
    [self.card returnToPriorState];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [UIView animateWithDuration:0.2 animations:^{
        }];
    }];
}


/**
 *  Abstract method for supporting the action of button1 on an expanded card
 *
 */
- (void)button0Tapped {

    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

/**
 *  Abstract method for supporting the action of button1 on an expanded card
 *
 */
- (void)button1Tapped {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

/**
 *  Supports building of buttons based on number required.
 */

-(void)updateViewConstraints {

    [super updateViewConstraints];
    
    if (!self.constraintsAlreadyUpdated && self.buttonView) {

    [self.buttonView removeConstraints:self.buttonView.constraints];

    for (NSString* key in self.viewsDictionary) {
        UIView *view = (UIView *)[self.viewsDictionary objectForKey:key];

        view.translatesAutoresizingMaskIntoConstraints = NO;
        [view removeConstraints:view.constraints];
    }
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.buttonView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44.0];
    
    [self.buttonView addConstraint:heightConstraint];
    
    NSArray *horizontalButtonConstraints;
    NSArray *verticalButtonConstraints;
    
    switch (self.buttonCount) {
            
        case 0:
            break; //no buttons to add
            
        case 1: {
            
            horizontalButtonConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button0]|" options:0 metrics:nil views:self.viewsDictionary];
            
            verticalButtonConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button0(==44)]|" options:0 metrics:nil views:self.viewsDictionary];
            
            break;
        }
            
        case 2: {
            
            horizontalButtonConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button0][button1(==button0)]|" options:0 metrics:nil views:self.viewsDictionary];
            
            NSArray * buttonOneVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[button0](==44)|" options:0 metrics:nil views:self.viewsDictionary];
            
            NSArray *buttonTwoVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[button1](==44)|" options:0 metrics:nil views:self.viewsDictionary];
            
            verticalButtonConstraints = [buttonOneVerticalConstraints arrayByAddingObjectsFromArray:buttonTwoVerticalConstraints];
            break;
        }
    }
    
    [self.buttonView addConstraints:horizontalButtonConstraints];
    [self.buttonView addConstraints:verticalButtonConstraints];
        
        self.constraintsAlreadyUpdated = YES;

    }
}


@end

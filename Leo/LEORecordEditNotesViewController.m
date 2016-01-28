//
//  LEORecordEditNotesViewController.m
//  Leo
//
//  Created by Adam Fanslau on 1/27/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEORecordEditNotesViewController.h"
#import "LEOStyleHelper.h"
#import "JVFloatLabeledTextView.h"
#import "UIColor+LeoColors.h"
#import "UIImage+Extensions.h"

#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

@interface LEORecordEditNotesViewController ()

@property (weak, nonatomic) JVFloatLabeledTextView *myTextView;
@property (nonatomic) BOOL alreadyUpdatedConstraints;
@property (weak, nonatomic) UIView *navigationBar;

@end

@implementation LEORecordEditNotesViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    [self registerForKeyboardNotifications];

    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:FeatureSettings withTitleText:self.patient.firstName dismissal:NO backButton:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;

    // Without this line, the view ends up getting resized to 0 height, and does not appear (for searching: black screen push animated)
    self.view.backgroundColor = [UIColor leo_white];
}

- (JVFloatLabeledTextView *)myTextView {

    if (!_myTextView) {

        JVFloatLabeledTextView *strongView = [JVFloatLabeledTextView new];
        [self.view addSubview:strongView];
        _myTextView = strongView;
        _myTextView.placeholder = @"Please enter some notes about your child";
    }

    return _myTextView;
}

- (UIView *)navigationBar {

    if (!_navigationBar) {

        UIView *strongView = [UIView new];
        [self.view addSubview:strongView];
        _navigationBar = strongView;
        _navigationBar.backgroundColor = [UIColor leo_orangeRed];
    }
    return _navigationBar;
}

- (void)loadView {

    [super loadView];

    self.myTextView.translatesAutoresizingMaskIntoConstraints = NO;
    self.navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(_myTextView, _navigationBar);

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_navigationBar]|" options:0 metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_navigationBar]-[_myTextView]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_myTextView]-|" options:0 metrics:nil views:views]];
}

#pragma mark  -  Keyboard Avoiding

- (void)registerForKeyboardNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [self updateInsetsToShowKeyboard:YES notification:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self updateInsetsToShowKeyboard:NO notification:notification];
}

- (void)updateInsetsToShowKeyboard:(BOOL)showing notification:(NSNotification*)notification {

    CGRect keyboardRect = [self.view convertRect:[[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    UIEdgeInsets insets = self.myTextView.contentInset;
    insets.bottom = showing ? CGRectGetHeight(keyboardRect) : 0;
    self.myTextView.contentInset = insets;
}




@end

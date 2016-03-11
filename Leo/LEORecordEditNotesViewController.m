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
#import "UIFont+LeoFonts.h"
#import "UIImage+Extensions.h"
#import "LEOHealthRecordService.h"
#import <MBProgressHUD.h>
#import "UIButton+Extensions.h"
#import "LEOAlertHelper.h"
#import "LEOApiReachability.h"

#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

@interface LEORecordEditNotesViewController ()

@property (weak, nonatomic) JVFloatLabeledTextView *textView;
@property (strong, nonatomic) UIToolbar *accessoryView;
@property (nonatomic) BOOL alreadyUpdatedConstraints;
@property (weak, nonatomic) UIView *navigationBar;

@end

@implementation LEORecordEditNotesViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    [self registerForKeyboardNotifications];
    [self setupReachability];
    [self setupNavigationBar];

    self.automaticallyAdjustsScrollViewInsets = NO;

    // Without this line, the view ends up getting resized to 0 height, and does not appear (for searching: black screen push animated)
    self.view.backgroundColor = [UIColor leo_white];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)setupReachability {

    [LEOApiReachability startMonitoringForController:self withOfflineBlock:^{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } withOnlineBlock:^{
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

- (void)setupNavigationBar {

    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:FeatureSettings withTitleText:self.patient.firstName dismissal:NO backButton:NO];
    self.navigationItem.titleView.alpha = 1;


    UIButton *doneButton = [UIButton leo_newButtonWithDisabledStyling];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont];
    [doneButton setTitleColor:[UIColor leo_white] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(saveBBIAction) forControlEvents:UIControlEventTouchUpInside];
    [doneButton sizeToFit];

    UIBarButtonItem *doneBBI = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = doneBBI;

}

- (void)dismiss {

    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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

- (JVFloatLabeledTextView *)textView {

    if (!_textView) {

        JVFloatLabeledTextView *strongView = [JVFloatLabeledTextView new];
        [self.view addSubview:strongView];
        _textView = strongView;

        _textView.text = self.note.text;
        _textView.font = [UIFont leo_standardFont];
        _textView.placeholder = @"Please enter some notes about your child";
        _textView.floatingLabelActiveTextColor = [UIColor leo_grayForPlaceholdersAndLines];
    }

    return _textView;
}

- (void)saveBBIAction {

    [self.view endEditing:YES];

    if (self.note) {

        self.note.text = self.textView.text;

        self.navigationItem.rightBarButtonItem.enabled = NO;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        [[LEOHealthRecordService new] putNote:self.note forPatient:self.patient withCompletion:^(PatientNote *updatedNote, NSError *error) {


            if (!error) {

                self.editNoteCompletionBlock(updatedNote);
                [self dismissViewControllerAnimated:YES completion:nil];
                
            } else {
                [LEOAlertHelper alertForViewController:self title:@"Something went wrong" message:@"We can't save your notes right now. Please try again in a little while."];
            }

            // update the note while we wait for the network
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.navigationItem.rightBarButtonItem.enabled = YES;

        }];

    } else {

        self.note = [PatientNote new];
        self.note.text = self.textView.text;

        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.navigationItem.rightBarButtonItem.enabled = NO;

        [[LEOHealthRecordService new] postNote:self.note.text forPatient:self.patient withCompletion:^(PatientNote *updatedNote, NSError *error) {

            if (!error) {

                self.editNoteCompletionBlock(updatedNote);
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [LEOAlertHelper alertForViewController:self title:@"Something went wrong" message:@"We can't save your notes right now. Please try again in a little while."];
            }

            self.navigationItem.rightBarButtonItem.enabled = YES;

            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

- (void)loadView {

    [super loadView];

    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    self.navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(_textView, _navigationBar);

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_navigationBar]|" options:0 metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_navigationBar]-[_textView]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_textView]-|" options:0 metrics:nil views:views]];
}

#pragma mark  -  Keyboard Avoiding

- (void)registerForKeyboardNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeObservers {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {

    [self removeObservers];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [self updateInsetsToShowKeyboard:YES notification:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self updateInsetsToShowKeyboard:NO notification:notification];
}

- (void)updateInsetsToShowKeyboard:(BOOL)showing notification:(NSNotification*)notification {

    CGRect keyboardRect = [self.view convertRect:[[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    UIEdgeInsets insets = self.textView.contentInset;
    insets.bottom = showing ? CGRectGetHeight(keyboardRect) : 0;
    self.textView.contentInset = insets;
}


@end

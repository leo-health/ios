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
#import "LEOHealthRecordService.h"
#import <MBProgressHUD.h>

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

    [self setupNavigationBar];

    self.automaticallyAdjustsScrollViewInsets = NO;

    // Without this line, the view ends up getting resized to 0 height, and does not appear (for searching: black screen push animated)
    self.view.backgroundColor = [UIColor leo_white];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)setupNavigationBar {

    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:FeatureSettings withTitleText:self.patient.firstName dismissal:NO backButton:NO];
    self.navigationItem.titleView.alpha = 1;
    
    UIBarButtonItem *saveBBI = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveBBIAction)];
    self.navigationItem.rightBarButtonItem = saveBBI;

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
        _textView.placeholder = @"Please enter some notes about your child";
        _textView.floatingLabelActiveTextColor = [UIColor leo_grayForPlaceholdersAndLines];
    }

    return _textView;
}

- (void)saveBBIAction {

    [self.view endEditing:YES];

    if (self.note) {

        self.note.text = self.textView.text;
        [[LEOHealthRecordService new] putNote:self.note forPatient:self.patient withCompletion:^(PatientNote *updatedNote, NSError *error) {

            // TODO: handle error
            self.editNoteCompletionBlock(updatedNote);
        }];

        // update the note while we wait for the network
        self.editNoteCompletionBlock(self.note);
        [self dismissViewControllerAnimated:YES completion:nil];

    } else {



        self.note = [PatientNote new];
        self.note.text = self.textView.text;

        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.navigationItem.leftBarButtonItem.enabled = NO;

        [[LEOHealthRecordService new] postNote:self.note.text forPatient:self.patient withCompletion:^(PatientNote *updatedNote, NSError *error) {

            // update with new obejctID
            self.editNoteCompletionBlock(updatedNote);

            // @zach: does your button disabling code handle bar button items?
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];

            // TODO: handle error
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

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


@end

//
//  LEOImagePreviewViewController.m
//  Leo
//
//  Created by Adam Fanslau on 2/10/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOImagePreviewViewController.h"
#import "LEOStyleHelper.h"
#import "UIColor+LeoColors.h"
#import "UIImage+Extensions.h"
#import "UIFont+LeoFonts.h"
#import "LEOImageCropViewControllerDataSource.h"
#import "LEOImageCropViewController.h"
#import "LEOConstants.h"

@interface LEOImagePreviewViewController ()

@property (strong, nonatomic) LEOImageCropViewControllerDataSource *cropDataSource;
@property (weak, nonatomic) UIView *imageCropView;
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UIView *toolbar;
@property (nonatomic) RSKImageCropMode cropMode;
@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) UIBarButtonItem *flexBBI;
@property (nonatomic) BOOL alreadyUpdatedConstraints;

@property (nonatomic) CGFloat originalToolbarHeight;
@property (nonatomic) BOOL originalLeftButtonHidden;
@property (nonatomic) BOOL originalRightButtonHidden;

@end

@implementation LEOImagePreviewViewController

// FIXME: When using custom transitions, the topLayoutGuide does not give the correct value.
// source: http://slidetorock.com/blog/toplayoutguide-and-custom-transistions-in-ios-7.html
CGFloat const kFakeTopLayoutGuide = 0; // not sure why, but this seems to be correct positioning without this now...
NSString * const kCopyPhotoPreview = @"Photo Preview";

@synthesize image = _image;
@synthesize leftToolbarButton = _leftToolbarButton;
@synthesize rightToolbarButton = _rightToolbarButton;
@synthesize imageCropController = _imageCropController;

- (instancetype)initWithImage:(UIImage *)image cropMode:(RSKImageCropMode)cropMode {

    self = [super init];
    if (self) {

        _originalImage = image;
        _cropMode = cropMode;

        // FIXME: refactor to not use setter for side effects
        self.toolbarHeight = kHeightDefaultToolbar;
    }

    return self;
}

- (instancetype)initWithNoCropModeWithImage:(UIImage *)image {

    self = [self initWithImage:image cropMode:RSKImageCropModeCustom];
    if (self) {
        [self setToolbarHidden:YES];
    }
    return self;
}

- (void)setToolbarHeight:(CGFloat)toolbarHeight {

    _toolbarHeight = toolbarHeight;
    self.originalToolbarHeight = toolbarHeight;
}

- (void)setToolbarHidden:(BOOL)hidden {

    if (hidden) {

        self.toolbarHeight = 0;
        self.originalLeftButtonHidden = self.leftToolbarButton.hidden;
        self.originalRightButtonHidden = self.rightToolbarButton.hidden;
        self.leftToolbarButton.hidden = YES;
        self.rightToolbarButton.hidden = YES;

    } else {

        self.toolbarHeight = self.originalToolbarHeight;
        self.leftToolbarButton.hidden = self.originalLeftButtonHidden;
        self.leftToolbarButton.hidden = self.originalRightButtonHidden;
    }
}

- (void)viewDidLoad {

    [super viewDidLoad];

    [self addChildViewController:self.imageCropController];

    [self.imageCropController didMoveToParentViewController:self];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [self setupConstraints];
    [self setupNavigationBar];
}

- (UIImage *)image {

    if (!_image) {
        return self.originalImage;
    }

    return _image;
}

- (LEOImageCropViewController *)imageCropController {

    if (!_imageCropController) {

        _imageCropController = [[LEOImageCropViewController alloc] initWithImage:self.image cropMode:self.cropMode];

        if (self.cropMode == RSKImageCropModeCustom) {

            self.cropDataSource = [LEOImageCropViewControllerDataSource new];
            _imageCropController.dataSource = self.cropDataSource;
        }

        _imageCropController.delegate = self;
        _imageCropController.moveAndScaleLabel.hidden = YES;
        _imageCropController.chooseButton.hidden = YES;
        _imageCropController.cancelButton.hidden = YES;

        // FIXME: refactor to not use accessors for side effects
        [self imageCropView];
    }

    return _imageCropController;
}

- (void)setZoomable:(BOOL)zoomable {

    _zoomable = zoomable;
    self.imageCropController.view.userInteractionEnabled = _zoomable;
}

- (UIView *)imageCropView {

    if (!_imageCropView) {

        UIView *strongView = _imageCropController.view;
        [self.view addSubview:strongView];
        [_imageCropController didMoveToParentViewController:self];
        _imageCropView = strongView;
        _imageCropView.backgroundColor = [UIColor leo_grayForMessageBubbles];
    }

    return _imageCropView;
}

/**
 *  Using this method in viewWillAppear to solve an issue where updateViewConstraints does not get called in signupPatient until a different instance is loaded in messaging
 */
- (void)setupConstraints {

    if (!self.alreadyUpdatedConstraints) {

        self.view.backgroundColor = [UIColor leo_grayForMessageBubbles];

        self.imageCropView.translatesAutoresizingMaskIntoConstraints = NO;
        self.toolbar.translatesAutoresizingMaskIntoConstraints = NO;
        self.leftToolbarButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.rightToolbarButton.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *views = NSDictionaryOfVariableBindings(_imageCropView, _toolbar, _leftToolbarButton, _rightToolbarButton);

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(fakeTopLayoutGuide)-[_imageCropView][_toolbar(toolbarHeight)]|" options:0 metrics:@{@"toolbarHeight":@(self.toolbarHeight), @"fakeTopLayoutGuide":@(kFakeTopLayoutGuide)} views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageCropView]|" options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:views]];

        [self.toolbar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[_leftToolbarButton]->=0-[_rightToolbarButton]-(padding)-|" options:0 metrics:@{@"padding":@(kPaddingHorizontalToolbarButtons)} views:views]];
        [self.toolbar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_rightToolbarButton]|" options:0 metrics:nil views:views]];
        [self.toolbar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_leftToolbarButton]|" options:0 metrics:nil views:views]];

        self.alreadyUpdatedConstraints = YES;
    }
}

- (UIView *)toolbar {

    if (!_toolbar) {

        UIView *strongView = [UIView new];
        [self.view addSubview:strongView];
        _toolbar = strongView;

        _toolbar.backgroundColor = [LEOStyleHelper backgroundColorForFeature:self.feature];
    }

    return _toolbar;
}

- (UIButton *)leftToolbarButton {

    if (!_leftToolbarButton) {

        _leftToolbarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftToolbarButton setTitle:@"CANCEL" forState:UIControlStateNormal];
        [_leftToolbarButton addTarget:self action:@selector(cancelBBIAction) forControlEvents:UIControlEventTouchUpInside];
        _leftToolbarButton.titleLabel.font = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont];
        [_leftToolbarButton setTitleColor:[LEOStyleHelper headerIconColorForFeature:self.feature] forState:UIControlStateNormal];
        [self.toolbar addSubview:_leftToolbarButton];
    }

    return _leftToolbarButton;
}

- (UIButton *)rightToolbarButton {

    if (!_rightToolbarButton) {

        _rightToolbarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightToolbarButton setTitle:@"CONFIRM" forState:UIControlStateNormal];
        [_rightToolbarButton addTarget:self action:@selector(confirmBBIAction) forControlEvents:UIControlEventTouchUpInside];
        _rightToolbarButton.titleLabel.font = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont];
        [_rightToolbarButton setTitleColor:[LEOStyleHelper headerIconColorForFeature:self.feature] forState:UIControlStateNormal];
        [self.toolbar addSubview:_rightToolbarButton];
    }

    return _rightToolbarButton;
}

- (void)setupNavigationBar {

    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:self.feature withTitleText:kCopyPhotoPreview dismissal:NO backButton:self.showsBackButton];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)cancelBBIAction {

    [self.imageCropController.cancelButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {

    if ([self.delegate respondsToSelector:@selector(imagePreviewControllerDidCancel:)]) {
        
        [self.delegate imagePreviewControllerDidCancel:self];
    }
}

- (void)confirmBBIAction {
    [self.imageCropController.chooseButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {

    _image = croppedImage;
    if ([self.delegate respondsToSelector:@selector(imagePreviewControllerDidConfirm:)]) {

        [self.delegate imagePreviewControllerDidConfirm:self];
    }
}


@end

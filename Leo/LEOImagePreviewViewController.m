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

@interface LEOImagePreviewViewController ()

@property (strong, nonatomic) LEOImageCropViewControllerDataSource *cropDataSource;
@property (weak, nonatomic) UIView *imageCropView;
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UIView *toolbar;
@property (nonatomic) RSKImageCropMode cropMode;
@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) UIBarButtonItem *flexBBI;
@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end

@implementation LEOImagePreviewViewController

CGFloat const kPaddingHorizontalToolbarButtons = 20;
CGFloat const kHeightDefaultToolbar = 44;

@synthesize image = _image;
@synthesize leftBarButtonItem = _leftBarButtonItem;
@synthesize rightBarButtonItem = _rightBarButtonItem;
@synthesize imageCropController = _imageCropController;

- (instancetype)initWithImage:(UIImage *)image cropMode:(RSKImageCropMode)cropMode {

    self = [super init];
    if (self) {

        _originalImage = image;
        _cropMode = cropMode;
        _toolbarHeight = kHeightDefaultToolbar;
    }

    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];

    [self addChildViewController:self.imageCropController];

    [self.imageCropController didMoveToParentViewController:self];

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
        [self imageCropView];
    }

    return _imageCropController;
}

- (UIView *)imageCropView {

    if (!_imageCropView) {
        UIView *strongView = _imageCropController.view;
        [self.view addSubview:strongView];
        [_imageCropController didMoveToParentViewController:self];
        _imageCropView = strongView;
        _imageCropView.backgroundColor = [UIColor leo_grayBlueForBackgrounds];
    }

    return _imageCropView;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self setupNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews {

    [super viewDidLayoutSubviews];

    NSLog(@"layout");
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
}

- (void)updateViewConstraints {

    [super updateViewConstraints];

    if (!self.alreadyUpdatedConstraints) {

        self.view.backgroundColor = [UIColor leo_grayBlueForBackgrounds];

        self.imageCropView.translatesAutoresizingMaskIntoConstraints = NO;
        self.toolbar.translatesAutoresizingMaskIntoConstraints = NO;
        self.leftBarButtonItem.translatesAutoresizingMaskIntoConstraints = NO;
        self.rightBarButtonItem.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *views = NSDictionaryOfVariableBindings(_imageCropView, _toolbar, _leftBarButtonItem, _rightBarButtonItem);

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageCropView][_toolbar(toolbarHeight)]|" options:0 metrics:@{@"toolbarHeight":@(self.toolbarHeight)} views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageCropView]|" options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:views]];

        [self.toolbar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[_leftBarButtonItem]->=0-[_rightBarButtonItem]-(padding)-|" options:0 metrics:@{@"padding":@(kPaddingHorizontalToolbarButtons)} views:views]];
        [self.toolbar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_rightBarButtonItem]|" options:0 metrics:nil views:views]];
        [self.toolbar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_leftBarButtonItem]|" options:0 metrics:nil views:views]];

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

- (UIButton *)leftBarButtonItem {

    if (!_leftBarButtonItem) {
        _leftBarButtonItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBarButtonItem setTitle:@"CANCEL" forState:UIControlStateNormal];
        [_leftBarButtonItem addTarget:self action:@selector(cancelBBIAction) forControlEvents:UIControlEventTouchUpInside];
        _leftBarButtonItem.titleLabel.font = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont];
        [_leftBarButtonItem setTitleColor:[LEOStyleHelper headerIconColorForFeature:self.feature] forState:UIControlStateNormal];
        [self.toolbar addSubview:_leftBarButtonItem];
    }
    return _leftBarButtonItem;
}

- (UIButton *)rightBarButtonItem {

    if (!_rightBarButtonItem) {
        _rightBarButtonItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBarButtonItem setTitle:@"CONFIRM" forState:UIControlStateNormal];
        [_rightBarButtonItem addTarget:self action:@selector(confirmBBIAction) forControlEvents:UIControlEventTouchUpInside];
        _rightBarButtonItem.titleLabel.font = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont];
        [_rightBarButtonItem setTitleColor:[LEOStyleHelper headerIconColorForFeature:self.feature] forState:UIControlStateNormal];
        [self.toolbar addSubview:_rightBarButtonItem];
    }
    return _rightBarButtonItem;
}

- (void)setupNavigationBar {

    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:self.feature withTitleText:@"Photo Preview" dismissal:NO backButton:self.showsBackButton];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)cancelBBIAction {

    [self.imageCropController.cancelButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {

    if ([self.delegate respondsToSelector:@selector(imagePreviewControllerDidChooseCancel:)]) {
        [self.delegate imagePreviewControllerDidChooseCancel:self];
    }
}

- (void)confirmBBIAction {
    [self.imageCropController.chooseButton sendActionsForControlEvents:UIControlEventTouchUpInside];

}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {

    _image = croppedImage;
    if ([self.delegate respondsToSelector:@selector(imagePreviewControllerDidChooseConfirm:)]) {
        [self.delegate imagePreviewControllerDidChooseConfirm:self];
    }
}


@end

//
//  LEOImagePreviewViewController.h
//  Leo
//
//  Created by Adam Fanslau on 2/10/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSKImageCropViewController.h"

@class LEOImagePreviewViewController, LEOImageCropViewController;

@protocol LEOImagePreviewDelegate <NSObject>

- (void)imagePreviewControllerDidCancel:(LEOImagePreviewViewController *)imagePreviewController;
- (void)imagePreviewControllerDidConfirm:(LEOImagePreviewViewController *)imagePreviewController;

@end

/**
 *  Using view controller containment here so we can customize the nav bar and toolbar that surround the crop view
 */
@interface LEOImagePreviewViewController : UIViewController <RSKImageCropViewControllerDelegate>

@property (strong, nonatomic, readonly) LEOImageCropViewController *imageCropController;
@property (strong, nonatomic, readonly) UIButton *leftToolbarButton;
@property (strong, nonatomic, readonly) UIButton *rightToolbarButton;
@property (nonatomic) Feature feature;
@property (nonatomic) BOOL zoomable;
@property (nonatomic) UIImagePickerControllerSourceType sourceType;
@property (weak, nonatomic) id<LEOImagePreviewDelegate> delegate;
@property (strong, nonatomic, readonly) UIImage *image;
@property (nonatomic) CGFloat toolbarHeight;
@property (nonatomic) BOOL showsBackButton;

- (instancetype)initWithNoCropModeWithImage:(UIImage *)image;
- (instancetype)initWithImage:(UIImage *)image cropMode:(RSKImageCropMode)cropMode;


@end

//
//  LEOSignUpChildViewController.h
//  Leo
//
//  Created by Zachary Drossman on 9/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StickyView.h"
#import "LEOPromptView.h"
#import <RSKImageCropper/RSKImageCropper.h>

@interface LEOSignUpChildViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, LEOPromptDelegate, StickyViewDelegate, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate>

@end

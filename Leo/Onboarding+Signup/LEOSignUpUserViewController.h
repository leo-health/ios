//
//  LEOSIgnUpUserViewController.h
//  Leo
//
//  Created by Zachary Drossman on 9/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOScrollableContainerView.h"
#import "LEOPromptView.h"
#import "SingleSelectionProtocol.h"

@interface LEOSignUpUserViewController : UIViewController <LEOScrollableContainerViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, LEOPromptDelegate, SingleSelectionProtocol>

@end

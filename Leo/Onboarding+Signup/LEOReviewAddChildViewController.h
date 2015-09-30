//
//  LEOReviewAddChildViewController.h
//  Leo
//
//  Created by Zachary Drossman on 9/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StickyView.h"
#import "LEOPromptView.h"

@interface LEOReviewAddChildViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, LEOPromptDelegate, StickyViewDelegate, UITableViewDelegate>

@property (strong, nonatomic) NSArray *childData;

@end

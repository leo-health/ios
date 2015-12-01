//
//  LEOWebViewController.h
//  Leo
//
//  Created by Zachary Drossman on 11/19/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEOWebViewController : UIViewController

@property (copy, nonatomic) NSString *urlString;
@property (copy, nonatomic) NSString *titleString;
@property (nonatomic) Feature feature;

@end

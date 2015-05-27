//
//  LEOEHRViewController.h
//  Leo
//
//  Created by Zachary Drossman on 5/26/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEOEHRViewController : UIViewController

@property (nonatomic) NSInteger childIndex;
@property (weak, nonatomic) IBOutlet UILabel *childName;
@property (strong, nonatomic) id childData;

@end

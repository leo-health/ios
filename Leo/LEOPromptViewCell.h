//
//  LEOPromptViewCell.h
//  Leo
//
//  Created by Zachary Drossman on 9/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LEOPromptView;

@interface LEOPromptViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet LEOPromptView *promptView;

+(UINib *)nib;

@end

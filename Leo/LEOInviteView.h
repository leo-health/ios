//
//  LEOInviteView.h
//  Leo
//
//  Created by Zachary Drossman on 10/9/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEOInviteView : UIView <UITextFieldDelegate>

@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *lastName;
@property (copy, nonatomic) NSString *email;

@property (nonatomic) Feature feature;

- (BOOL)isValidInvite;

@end

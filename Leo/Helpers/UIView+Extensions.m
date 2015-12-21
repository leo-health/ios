//
//  UIView+Extensions.m
//  Leo
//
//  Created by Zachary Drossman on 10/5/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "UIView+Extensions.h"

@implementation UIView (Extensions)

- (NSLayoutConstraint *)leo_pin:(id)item attribute:(NSLayoutAttribute)attribute {
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:item
                                        attribute:attribute
                                       multiplier:1.0
                                         constant:0.0];
}

- (void)viewTapped {
    
    [self endEditing:YES];
}

//TODO: Eventually should move into a protocol or superclass potentially.
- (void)setupTouchEventForDismissingKeyboard {
    
    UITapGestureRecognizer *tapGestureForTextFieldDismissal = [[UITapGestureRecognizer alloc]initWithTarget:nil action:@selector(viewTapped)];
    
    tapGestureForTextFieldDismissal.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGestureForTextFieldDismissal];
}


@end

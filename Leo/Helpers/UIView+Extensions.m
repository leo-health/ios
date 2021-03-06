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

- (void)leo_viewTapped {
    [self endEditing:YES];
}

- (void)setupTouchEventForDismissingKeyboard {
    
    UITapGestureRecognizer *tapGestureForTextFieldDismissal =
    [[UITapGestureRecognizer alloc] initWithTarget:nil
                                            action:@selector(leo_viewTapped)];
    
    tapGestureForTextFieldDismissal.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGestureForTextFieldDismissal];
}

- (void)leo_pinToSuperView:(UIView *)superview {

    self.translatesAutoresizingMaskIntoConstraints = NO;

    [superview addSubview:self];

    UIView *viewToPin = self;

    NSDictionary *bindings = NSDictionaryOfVariableBindings(viewToPin);

    [superview addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[viewToPin]|"
                                             options:0
                                             metrics:nil
                                               views:bindings]];

    [superview addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[viewToPin]|"
                                             options:0
                                             metrics:nil
                                               views:bindings]];
}


@end

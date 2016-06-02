//
//  LEOPaymentsView.h
//  Leo
//
//  Created by Zachary Drossman on 4/29/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Stripe.h>
#import <UIKit/UIKit.h>

@protocol LEOPaymentViewProtocol <NSObject>

//TODO: May want to make number of children and charge per child part of the protocol.

- (void)saveButtonTouchedUpInside:(UIButton *)sender
                       parameters:(STPCardParams *)cardParams;

@end

@interface LEOPaymentsView : UIView

- (instancetype)initWithNumberOfChildren:(NSInteger)numberOfChildren
                                  charge:(NSInteger)chargePerChild
                          managementMode:(ManagementMode)managementMode;

@property (nonatomic) NSInteger numberOfChildren;
@property (nonatomic) NSInteger chargePerChild;
@property (nonatomic) ManagementMode managementMode;

@property (weak, nonatomic) id<LEOPaymentViewProtocol> delegate;

@end

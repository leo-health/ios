//
//  LEOPaymentsView.h
//  Leo
//
//  Created by Zachary Drossman on 4/29/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Stripe/Stripe.h>
#import <UIKit/UIKit.h>
#import "LEOValidatedFloatLabeledTextView.h"
#import "LEOPromptView.h"
#import "LEOPromoCodeSuccessView.h"

@protocol LEOPaymentViewProtocol <NSObject>

//TODO: May want to make number of children and charge per child part of the protocol.

- (void)saveButtonTouchedUpInside:(UIButton *)sender
                       parameters:(STPCardParams *)cardParams;

- (void)applyPromoCodeTapped:(LEOPromptView *)sender;

@end

@interface LEOPaymentsView : UIView

- (instancetype)initWithNumberOfChildren:(NSInteger)numberOfChildren
                                  charge:(NSInteger)chargePerChild
                          managementMode:(ManagementMode)managementMode;

@property (nonatomic) NSInteger numberOfChildren;
@property (nonatomic) NSInteger chargePerChild;
@property (nonatomic) ManagementMode managementMode;

@property (weak, nonatomic) IBOutlet LEOPromoCodeSuccessView *promoSuccessView;
@property (weak, nonatomic) IBOutlet LEOPromptView *promoPromptView;
@property (nonatomic) BOOL promoPromptViewHidden;

// TODO: should be part of a LEOPromptViewAsync
@property (weak, nonatomic) UIButton *applyPromoButton;
@property (weak, nonatomic) UIActivityIndicatorView *hud;

@property (weak, nonatomic) id<LEOPaymentViewProtocol> delegate;

@end

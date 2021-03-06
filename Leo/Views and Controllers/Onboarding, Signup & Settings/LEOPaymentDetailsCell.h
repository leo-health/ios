//
//  LEOPaymentDetailsCell.h
//  Leo
//
//  Created by Zachary Drossman on 5/3/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+Extensions.h"
#import "LEOPromoCodeSuccessView.h"

@interface LEOPaymentDetailsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *chargeDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet LEOPromoCodeSuccessView *promoCodeSuccessView;
@property (nonatomic) BOOL promoCodeSuccessViewVisible;

@end

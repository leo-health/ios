//
//  LEOPaymentDetailsCell.m
//  Leo
//
//  Created by Zachary Drossman on 5/3/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOPaymentDetailsCell.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"

@interface LEOPaymentDetailsCell ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightPromoCodeSuccessView;

@end

@implementation LEOPaymentDetailsCell

@dynamic promoCodeSuccessViewVisible;

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setChargeDetailLabel:(UILabel *)chargeDetailLabel {

    _chargeDetailLabel = chargeDetailLabel;

    _chargeDetailLabel.numberOfLines = 0;
    _chargeDetailLabel.lineBreakMode = NSLineBreakByWordWrapping;

    _chargeDetailLabel.font = [UIFont leo_regular15];
    _chargeDetailLabel.textColor = [UIColor leo_gray124];
}

- (void)setCardDetailLabel:(UILabel *)cardDetailLabel {

    _cardDetailLabel = cardDetailLabel;

    _cardDetailLabel.font = [UIFont leo_medium19];
    _cardDetailLabel.textColor = [UIColor leo_gray124];
}

//TODO: Remove "button, replace with UILabel, since we aren't actually using functionality of the control after all.
- (void)setEditButton:(UIButton *)editButton {

    _editButton = editButton;

    _editButton.titleLabel.font = [UIFont leo_bold12];
    [_editButton setTitleColor:[UIColor leo_orangeRed]
                          forState:UIControlStateNormal];
    _editButton.enabled = NO;
}

- (BOOL)promoCodeSuccessViewVisible {
    return !self.promoCodeSuccessView.hidden;
}

- (void)setPromoCodeSuccessViewVisible:(BOOL)promoCodeSuccessViewVisible {

    if (promoCodeSuccessViewVisible != self.promoCodeSuccessViewVisible) {
        if (promoCodeSuccessViewVisible) {
            [self.promoCodeSuccessView removeConstraint:self.heightPromoCodeSuccessView];
        } else {
            [self.promoCodeSuccessView addConstraint:self.heightPromoCodeSuccessView];
        }

        self.promoCodeSuccessView.hidden = !promoCodeSuccessViewVisible;
    }
}


@end

//
//  LEOLoggedOutOnboardingCell.h
//  Leo
//
//  Created by Adam Fanslau on 1/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOSwipeArrowsView.h"

@interface LEOLoggedOutOnboardingCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIView *swipeArrowsContainerView;
@property (weak, nonatomic) LEOSwipeArrowsView *swipeArrowsView;


+ (UINib*)nib;

@end

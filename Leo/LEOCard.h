//
//  LEOCard.h
//  
//
//  Created by Zachary Drossman on 5/15/15.
//
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface LEOCard : UIView

@property (strong, nonatomic, nonnull) UIView *headerView;
@property (strong, nonatomic, nullable) UIView *subheaderView;
@property (strong, nonatomic, nullable) NSArray *buttonArray;
@property (strong, nonatomic, nonnull) UIColor *localTintColor;
@property (strong, nonatomic, nonnull) UIImageView *iconImageView;

@end

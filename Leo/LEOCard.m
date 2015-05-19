//
//  LEOCard.m
//  
//
//  Created by Zachary Drossman on 5/15/15.
//
//

/*
 
 Color for top and bottom of card
 Buttons array and drawing of them
 Icon and indentation
 Badges?
 Title field
 Child's name
 
 
*/
 
#import "LEOCard.h"

@implementation LEOCard

- (instancetype)initWithHeaderView:(UIView *)headerView subheaderView:(UIView *)subheaderView buttonArray:(NSArray *)buttonArray localTintColor:(UIColor *)localTintColor iconImageView:(UIImageView *)iconImageView
{
    self = [super init];
    if (self) {
        self.headerView = headerView;
        self.subheaderView = subheaderView;
        self.buttonArray = buttonArray;
        self.localTintColor = localTintColor;
        self.iconImageView = iconImageView;
    }
    
    return self;
}

@end

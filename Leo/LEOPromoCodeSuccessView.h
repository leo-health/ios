//
//  LEOPromoCodeSuccessView.h
//  Leo
//
//  Created by Adam Fanslau on 7/28/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 
 TODO: later: this class is unneccessary, remove & replace with the following

 The more you know (how to do this in just a few lines of code and remove the entire class):

 http://sandmoose.com/post/119308328862/adding-an-image-to-a-uilabel

 and if you feel like a text field might be appropriate, although probably not in this case:
 https://developer.apple.com/library/ios/documentation/UIKit/Reference/UITextField_Class/
 search "Using Overlay Views"

 */

@interface LEOPromoCodeSuccessView : UIView

@property (weak, nonatomic) UIImageView *checkmarkImageView;
@property (weak, nonatomic) UILabel *successMessageLabel;

@end

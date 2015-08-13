//
//  UIFont+LeoFonts.h
//  
//
//  Created by Zachary Drossman on 5/11/15.
//
//

#import <UIKit/UIKit.h>

@interface UIFont (LeoFonts)

//TODO: Placeholders, and temporary until switching over to Text Styles for use with Dynamic Type


//FIXME: Remove these first six methods and associated places they are used in the code base when we return to updating layout.
+ (UIFont *)leoTitleBasicFont;
+ (UIFont *)leoTitleBoldFont;
+ (UIFont *)leoTitleBolderFont;

+ (UIFont *)leoBodyBasicFont;
+ (UIFont *)leoBodyBoldFont;
+ (UIFont *)leoBodyBolderFont;

+ (UIFont *)leoBasicSelectionFont;
+ (UIFont *)leoBodyFont;
+ (UIFont *)leoTitleFont;
+ (UIFont *)leoUserFont;
+ (UIFont *)leoButtonFont;
+ (UIFont *)leoChatTimestampLabelFont;
+ (UIFont *)leoQuestionFont;
+ (UIFont *)leoHeaderFont;
+ (UIFont *)leoHeaderLightFont;
+ (UIFont *)leoCondensedTimePeriodFont;

@end
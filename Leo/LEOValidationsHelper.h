//
//  LEOValidations.h
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOValidationsHelper : NSObject

+ (BOOL)phoneNumberTextField:(UITextField *)textField shouldUpdateCharacters:(NSString *)string inRange:(NSRange)range;
+ (BOOL)validatePhoneNumberWithFormatting:(NSString *)candidate;
+ (BOOL)validateNonZeroLength:(NSString *)candidate;
+ (BOOL)validateEmail: (NSString *) candidate;

@end

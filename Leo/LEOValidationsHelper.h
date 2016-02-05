//
//  LEOValidations.h
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOValidationsHelper : NSObject

+ (NSString *)formattedPhoneNumberFromPhoneNumber:(NSString*)digitsOnlyPhoneNumber;
+ (BOOL)phoneNumberTextField:(UITextField *)textField shouldUpdateCharacters:(NSString *)string inRange:(NSRange)range;
+ (BOOL)isValidPhoneNumberWithFormatting:(NSString *)candidate;
+ (BOOL)isValidEmail:(NSString *) candidate;
+ (BOOL)isValidFirstName:(NSString *)candidate;
+ (BOOL)isValidLastName:(NSString *)candidate;
+ (BOOL)isValidBirthDate:(NSDate *)candidate;
+ (BOOL)isValidGender:(NSString *)candidate;
+ (BOOL)isValidAvatar:(UIImage *)candidate;
+ (BOOL)isValidInsurer:(NSString *)candidate;
+ (BOOL)isValidPassword:(NSString *)candidate;
+ (BOOL)isValidPassword:(NSString *)candidate matching:(NSString *)otherCandidate error:(NSError * __autoreleasing *)error;

@end

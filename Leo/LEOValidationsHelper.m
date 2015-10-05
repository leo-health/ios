//
//  LEOValidations.m
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOValidationsHelper.h"
#import "NSDate+Extensions.h"

@implementation LEOValidationsHelper


//MARK: This method belongs elsewhere.
+ (BOOL)phoneNumberTextField:(UITextField *)textField shouldUpdateCharacters:(NSString *)string inRange:(NSRange)range {
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray *components = [newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
    NSString *decimalString = [components componentsJoinedByString:@""];
    
    NSUInteger length = decimalString.length;
    BOOL hasLeadingOne = length > 0 && [decimalString characterAtIndex:0] == '1';
    
    if ((length > 10 && !hasLeadingOne) || (length > 11)) {
        //            textField.text = decimalString;
        return NO;
    }
    
    NSUInteger index = 0;
    NSMutableString *formattedString = [NSMutableString string];
    
    if (hasLeadingOne && ![string isEqualToString:@""]) {
        [formattedString appendString:@"1 "];
        index += 1;
    }
    
    if (length - index > 3) {
        NSString *areaCode = [decimalString substringWithRange:NSMakeRange(index, 3)];
        [formattedString appendFormat:@"(%@) ",areaCode];
        index += 3;
    }
    
    if (length - index > 3) {
        NSString *prefix = [decimalString substringWithRange:NSMakeRange(index, 3)];
        [formattedString appendFormat:@"%@-",prefix];
        index += 3;
    }
    
    //        if (length > 11 && hasLeadingOne) {
    //            return NO;
    //        }
    //
    //        if (length > 10 && !hasLeadingOne) {
    //            return NO;
    //        }
    
    NSString *remainder = [decimalString substringFromIndex:index];
    [formattedString appendString:remainder];
    
    textField.text = formattedString;
    
    return NO;
}

+ (BOOL)isValidPhoneNumberWithFormatting:(NSString *)candidate {
    
    NSString *phoneRegex =@"1?[ ]?[(][1-9][0-9]{2}[)][ ][1-9][0-9]{2}[-][0-9]{4}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:candidate];
}


+ (BOOL)isValidEmail:(NSString *) candidate {
    
    NSString *emailRegex = @"\\A\\s*([^@\\s]{1,64})@((?:[-\\p{L}\\d]+\\.)+\\p{L}{2,})\\s*\\z";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL)isValidFirstName:(NSString *)candidate {
    return [self isValidNonZeroLength:candidate] ? YES : NO;
}

+ (BOOL)isValidLastName:(NSString *)candidate {
    return [self isValidNonZeroLength:candidate] ? YES : NO;
}

+ (BOOL)isValidBirthDate:(NSString *)candidate {
    return [self isValidShortDate:candidate];
}

+ (BOOL)isValidGender:(NSString *)candidate {
    return [self isValidNonZeroLength:candidate];
}

+ (BOOL)isValidInsurer:(NSString *)candidate {
    return [self isValidNonZeroLength:candidate];
}

+ (BOOL)isValidPassword:(NSString *)candidate {
    return candidate.length > 7;
}

#pragma mark - Internal
+ (BOOL)isValidNonZeroLength:(NSString *)candidate {
    return candidate.length > 0;
}

+ (BOOL)isValidAlphaOnly:(NSString *)candidate {
    NSString *alphaRegex = @"^[a-zA-Z]*$";
    NSPredicate *alphaOnlyTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", alphaRegex];
    
    return [alphaOnlyTest evaluateWithObject:candidate];
};

+ (BOOL)isValidShortDate:(NSString *)candidate {
    
    NSDate *date = [NSDate dateFromShortDate:candidate];
    
    return ([date isKindOfClass:[NSDate class]] && date != nil) ? YES : NO;
}

@end

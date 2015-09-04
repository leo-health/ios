//
//  LEOValidations.m
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOValidationsHelper.h"

@implementation LEOValidationsHelper

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

+ (BOOL)validatePhoneNumberWithFormatting:(NSString *)candidate {
    
    NSString *phoneRegex =@"1?[ ]?[(][1-9][0-9]{2}[)][ ][1-9][0-9]{2}[-][0-9]{4}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:candidate];
}

+ (BOOL)validateNonZeroLength:(NSString *)candidate {
    return candidate.length > 0;
}


@end

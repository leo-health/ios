//
//  ProviderCell+ConfigureCell.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/5/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "ProviderCell+ConfigureCell.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "Provider.h"

@implementation ProviderCell (ConfigureCell)

- (void)configureForProvider:(Provider *)provider {
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentLeft];
    [style setLineBreakMode:NSLineBreakByWordWrapping]; //TODO: May want to do some sort of resizing of the text here such that we don't end up wrapping ever.
    
    UIFont *font1 = [UIFont leo_medium15];
    UIFont *font2 = [UIFont leo_bold12];
    
    UIColor *color1 = [UIColor leo_gray74];
    UIColor *color2 = [UIColor leo_gray124];
    
    NSDictionary *attributedDictionary1 = @{NSForegroundColorAttributeName:color1,
                                            NSFontAttributeName:font1,
                                            NSParagraphStyleAttributeName:style};
    
    NSDictionary *attributedDictionary2 = @{NSForegroundColorAttributeName:color2,
                                            NSFontAttributeName:font2,
                                            NSParagraphStyleAttributeName:style};
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    
    
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", provider.fullName]
                                                                       attributes:attributedDictionary1]];
    
    
    NSString *credential = [provider.credentials[0] stringByReplacingOccurrencesOfString:@"." withString:@""];  //TODO: This will need to be updated at some point when we decide how we want to handle these.
    
    if (credential) {
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:credential
                                                                       attributes:attributedDictionary2]];
    }
    
    self.fullNameLabel.attributedText = attrString;
}

@end

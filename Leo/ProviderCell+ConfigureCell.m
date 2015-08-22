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
        
        UIFont *font1 = [UIFont leoBodyBoldFont];
        UIFont *font2 = [UIFont leoBodyBoldFont];
        
        UIColor *color1 = [UIColor leoBlack];
        UIColor *color2 = [UIColor leoGrayBodyText];
        
        NSDictionary *attributedDictionary1 = @{NSForegroundColorAttributeName:color1,
                                                NSFontAttributeName:font1,
                                                NSParagraphStyleAttributeName:style};
        
        NSDictionary *attributedDictionary2 = @{NSForegroundColorAttributeName:color2,
                                                NSFontAttributeName:font2,
                                                NSParagraphStyleAttributeName:style};
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    
        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:provider.fullName
                                                                           attributes:attributedDictionary1]];
        
        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:provider.credentials[0]
                                                                           attributes:attributedDictionary2]];
    
    self.fullNameLabel.attributedText = attrString;
}

@end
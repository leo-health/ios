//
//  LEOTimeCell+ConfigureCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/6/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOTimeCell+ConfigureCell.h"
#import "NSDate+Extensions.h"
#import "Slot.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"

@implementation LEOTimeCell (ConfigureCell)

- (void)configureForSlot:(Slot *)slot {
    
    NSMutableAttributedString *attributedTime = [[NSMutableAttributedString alloc] init];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentLeft];
    
    UIFont *font1 = [UIFont leo_demiBold17];
    UIColor *color1 = [UIColor leo_gray124];
    
    NSDictionary *attributedDictionary1 = @{NSForegroundColorAttributeName:color1,
                                            NSFontAttributeName:font1,
                                            NSParagraphStyleAttributeName:style};
    
    
    
    NSString *timeString = [NSDate leo_stringifiedTimeWithEasternTimeZoneWithoutPeriod:slot.startDateTime];
    
    NSAttributedString *formattedTimeString = [[NSAttributedString alloc] initWithString:timeString attributes:attributedDictionary1];
    
    [attributedTime appendAttributedString:formattedTimeString];


    UIFont *font2 = [UIFont leo_condensedRegular12];
    UIColor *color2 = [UIColor leo_gray124];
    
    NSDictionary *attributedDictionary2 = @{NSForegroundColorAttributeName:color2,
                                            NSFontAttributeName:font2,
                                            NSParagraphStyleAttributeName:style};

    NSString *timePeriodString = [NSDate leo_stringifiedTimePeriod:slot.startDateTime];
    
    NSAttributedString *formattedSpacingString = [[NSAttributedString alloc] initWithString:@" " attributes:attributedDictionary2];
    
    [attributedTime appendAttributedString:formattedSpacingString];
    
    NSAttributedString *formattedTimePeriodString = [[NSAttributedString alloc] initWithString:timePeriodString attributes:attributedDictionary2];
    
    [attributedTime appendAttributedString:formattedTimePeriodString];
    
    self.timeLabel.attributedText = attributedTime;
    
    self.selected = NO;
}

- (NSRange)timeRangeForString:(NSString *)string {
    
    return NSMakeRange(0, string.length - 2);
}

- (NSRange)timePeriodRangeForString:(NSString *)string {
    
    return NSMakeRange(string.length - 2, 2);
}


@end

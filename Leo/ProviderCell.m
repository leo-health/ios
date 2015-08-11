//
//  ProviderCell.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/5/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "ProviderCell.h"

@implementation ProviderCell

- (void)awakeFromNib {

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+(UINib *)nib {
    
    return [UINib nibWithNibName:@"ProviderCell" bundle:nil];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    if (selected) {
        
        NSMutableAttributedString *provider = [self.fullNameLabel.attributedText mutableCopy];
        
        NSRange range = NSMakeRange(0, [provider length]);
        
        [provider beginEditing];
        
        [provider addAttribute:NSUnderlineStyleAttributeName value:@(2.0) range:range];
        [provider addAttribute:NSForegroundColorAttributeName value:self.selectedColor range:range];
        [provider endEditing];
        
        self.fullNameLabel.attributedText = provider;
    }
}

@end

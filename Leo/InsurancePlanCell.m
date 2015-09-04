//
//  InsurerCell.m
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "InsurancePlanCell.h"

@implementation InsurancePlanCell

- (void)awakeFromNib {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+(UINib *)nib {
    
    return [UINib nibWithNibName:@"InsurancePlanCell" bundle:nil];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    if (selected) {
        
        NSMutableAttributedString *insurer = [self.insurancePlanLabel.attributedText mutableCopy];
        
        NSRange range = NSMakeRange(0, [insurer length]);
        
        [insurer beginEditing];
        
        [insurer addAttribute:NSUnderlineStyleAttributeName value:@(selectionLineHeight) range:range];
        [insurer addAttribute:NSForegroundColorAttributeName value:self.selectedColor range:range];
        [insurer endEditing];
        
        self.insurancePlanLabel.attributedText = insurer;
    }
}

@end

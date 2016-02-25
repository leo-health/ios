//
//  LEOFeedHeaderCell.m
//  Leo
//
//  Created by Zachary Drossman on 2/23/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOFeedHeaderCell.h"

#import "UIColor+LeoColors.h"

@implementation LEOFeedHeaderCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor leo_orangeRed];

    self.messageTextView.editable = NO;
    self.messageTextView.dataDetectorTypes = UIDataDetectorTypeLink;
    self.messageTextView.textAlignment = NSTextAlignmentCenter;
    self.messageTextView.scrollEnabled = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.layer.shadowOffset = CGSizeMake(0,1);
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius = 1;
    self.layer.masksToBounds = NO;
    self.clipsToBounds = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setHighlighted:(BOOL)highlighted {

    self.backgroundColor = [UIColor leo_orangeRed];
}

+ (UINib *)nib {

    return [UINib nibWithNibName:@"LEOFeedHeaderCell" bundle:nil];
}


@end

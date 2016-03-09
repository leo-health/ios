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
    self.messageTextView.selectable = YES;
    self.messageTextView.dataDetectorTypes = UIDataDetectorTypeLink;
    self.messageTextView.textAlignment = NSTextAlignmentCenter;
    self.messageTextView.scrollEnabled = NO;

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([LEOFeedHeaderCell class]) bundle:nil];
}


@end

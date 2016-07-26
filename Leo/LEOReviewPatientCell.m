//
//  LEOReviewChildCell.m
//  Leo
//
//  Created by Zachary Drossman on 10/5/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOReviewPatientCell.h"

@implementation LEOReviewPatientCell

- (void)awakeFromNib {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    //TODO: Remove "button, replace with UILabel, since we aren't actually using functionality of the control after all.
    self.editButton.enabled = NO;
}


@end

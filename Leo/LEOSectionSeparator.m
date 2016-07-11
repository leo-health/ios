//
//  LEOSectionSeparator.m
//  Leo
//
//  Created by Zachary Drossman on 6/16/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOSectionSeparator.h"
#import "UIColor+LeoColors.h"
@implementation LEOSectionSeparator

//- (void)awakeFromNib {
//    
//}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor leo_gray176];
}
-(CGSize)intrinsicContentSize {
    return CGSizeMake(self.frame.size.width, 1.0);
}

@end

//
//  UITableViewCell+Extensions.m
//  Leo
//
//  Created by Zachary Drossman on 5/4/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "UITableViewCell+Extensions.h"

@implementation UITableViewCell (Extensions)

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

@end

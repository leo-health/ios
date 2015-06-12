//
//  BasicSelectionTableViewDelegate.h
//  Leo
//
//  Created by Zachary Drossman on 6/8/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
#import "LEODropDownSelectionProtocol.h"


@interface LEODropDownTableViewDelegate : NSObject <UITableViewDelegate>

@property (weak, nonatomic) id<LEODropDownSelectionProtocol>delegate;

- (instancetype)initWithItems:(NSArray *)items;

@end

//
//  LEODropDownController.h
//  Leo
//
//  Created by Zachary Drossman on 6/8/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEODropDownSelectionProtocol.h"

@class LEODropDownTableView;

@interface LEODropDownController : NSObject <LEODropDownSelectionProtocol, UITableViewDelegate>

@property (strong, nonatomic) id selectedItem;
@property (strong, nonatomic) id associatedCardObject;

- (instancetype)initWithTableView:(LEODropDownTableView *)tableView items:(NSArray *)items usingDescriptorKey:(NSString *)descriptorKey associatedCardObject:(id)associatedCardObject;

@end     
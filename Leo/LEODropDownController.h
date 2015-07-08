//
//  LEODropDownController.h
//  Leo
//
//  Created by Zachary Drossman on 6/8/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

//@protocol DropDownActivityProtocol <NSObject>
//
//- (void)didSelectItemAtIndex:(NSUInteger)index tableView:(UITableView *)tableView;
//
//@end

@class LEODropDownTableView;

@interface LEODropDownController : NSObject <UITableViewDelegate, UITableViewDataSource>

//@property (weak, nonatomic) id<DropDownActivityProtocol>delegate;



#pragma mark - Designated Initializer and Initializer Helper Methods

- (instancetype)initWithTableView:(LEODropDownTableView *)tableView items:(NSArray *)items usingDescriptorKey:(NSString *)descriptorKey prepObject:(id)prepObject associatedCardObjectPropertyDescriptor:(NSString *)cardPropertyDescriptor;

@end

//
//  listItem.h
//  Leo
//
//  Created by Zachary Drossman on 6/8/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOListItem : NSObject

@property (strong, nonatomic) NSString *name;
@property (nonatomic) BOOL selected;

- (instancetype)initWithName:(NSString *)name;

@end

//
//  NSObject+XibAdditions.h
//  Leo
//
//  Created by Zachary Drossman on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (XibAdditions)

- (id)leo_loadViewFromNibForClass:(Class)class;

@end

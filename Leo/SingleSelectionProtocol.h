//
//  SingleSelectionProtocol.h
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/8/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SingleSelectionProtocol <NSObject>

- (void)didUpdateItem:(id)item forKey:(NSString *)key;

@end

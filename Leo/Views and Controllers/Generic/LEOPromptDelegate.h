//
//  LEOPromptDelegate.h
//  Leo
//
//  Created by Zachary Drossman on 12/16/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LEOPromptDelegate <NSObject>

- (void)respondToPrompt:(id)sender;

@end
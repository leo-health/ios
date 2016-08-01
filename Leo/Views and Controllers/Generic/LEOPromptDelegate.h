//
//  LEOPromptDelegate.h
//  Leo
//
//  Created by Zachary Drossman on 12/16/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

@class LEOPromptView;

#import <Foundation/Foundation.h>

@protocol LEOPromptDelegate <NSObject>

@optional
- (void)respondToPrompt:(id)sender;

@optional
- (void)promptViewDidChangeValid:(LEOPromptView *)promptView;

@end
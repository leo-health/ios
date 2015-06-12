//
//  LEODropDownSelectionProtocol.h
//  Leo
//
//  Created by Zachary Drossman on 6/12/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LEODropDownSelectionProtocol <NSObject>

- (void)didChooseItemAtIndexPath:(NSIndexPath *)indexPath;

@end

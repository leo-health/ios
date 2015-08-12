//
//  UIView_Overrides.h
//  Leo
//
//  Created by Zachary Drossman on 8/12/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView ()

- (CGSize) intrinsicContentSize {
    
    CGSize s = [super intrinsicContentSize];
    
    return CGSizeMake(s.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right,
                      s.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom);
    
}

@end

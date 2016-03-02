//
//  LEOInputAccessoryView.h
//  Leo
//
//  Created by Adam Fanslau on 3/2/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEOInputAccessoryView : UIView

@property (nonatomic) Feature feature;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

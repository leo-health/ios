//
//  LEOValidatedFloatLabeledTextView.h
//  Leo
//
//  Created by Zachary Drossman on 12/16/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JVFloatLabeledTextView.h"

@interface LEOValidatedFloatLabeledTextView : JVFloatLabeledTextView

@property (nonatomic) BOOL valid;
@property (strong, nonatomic) NSString *validationPlaceholder;
@property (strong, nonatomic) NSString *standardPlaceholder;

@end

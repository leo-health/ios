//
//  LEOValidatedFloatLabeledTextField.h
//  Leo
//
//  Created by Zachary Drossman on 9/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "JVFloatLabeledTextField.h"

@interface LEOValidatedFloatLabeledTextField : JVFloatLabeledTextField

@property (nonatomic) BOOL valid;
@property (strong, nonatomic) NSString *validationPlaceholder;
@property (strong, nonatomic) NSString *standardPlaceholder;

@end

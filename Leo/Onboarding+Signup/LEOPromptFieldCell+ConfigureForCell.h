//
//  LEOPromptFieldCell+ConfigureForPatient.h
//  Leo
//
//  Created by Zachary Drossman on 9/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOPromptFieldCell.h"
#import "Patient.h"

@interface LEOPromptFieldCell (ConfigureForPatient)

- (void)configureForPatient:(Patient *)patient;
- (void)configureForNewPatient;

@end

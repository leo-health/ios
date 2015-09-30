//
//  LEOPromptViewCell+ConfigureForPatient.h
//  Leo
//
//  Created by Zachary Drossman on 9/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOPromptViewCell.h"
#import "Patient.h"

@interface LEOPromptViewCell (ConfigureForPatient)

- (void)configureForPatient:(Patient *)patient;

@end

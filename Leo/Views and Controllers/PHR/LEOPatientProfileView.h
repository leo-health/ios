//
//  LEOChildHeaderView.h
//  Leo
//
//  Created by Zachary Drossman on 12/27/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

@class Patient;

#import <UIKit/UIKit.h>
#import "LEOSignUpPatientViewController.h"
#import "LEONavigateToEditPatient.h"

@interface LEOPatientProfileView : UIView <SignUpPatientProtocol>

- (instancetype)initWithPatient:(Patient *)patient;

@property (strong, nonatomic) Patient *patient;
@property (weak, nonatomic) id <LEONavigateToEditPatient>  delegate;


@end

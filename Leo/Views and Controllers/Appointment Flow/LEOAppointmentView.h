//
//  LEOAppointmentView.h
//  Leo
//
//  Created by Zachary Drossman on 11/23/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

@class Provider, Patient, AppointmentType, Appointment;

#import <UIKit/UIKit.h>
#import "LEOPromptField.h"

@protocol LEOAppointmentViewDelegate <NSObject>

- (void)leo_performSegueWithIdentifier:(NSString *)segueIdentifier;

@end

@interface LEOAppointmentView : UIView <UITextViewDelegate, UIScrollViewDelegate, LEOPromptDelegate>

@property (strong, nonatomic) Provider *provider;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) Patient *patient;
@property (strong, nonatomic) AppointmentType *appointmentType;
@property (copy, nonatomic) NSString *note;
@property (weak, nonatomic) id<LEOAppointmentViewDelegate>delegate;

@property (strong, nonatomic) Appointment *appointment;

- (instancetype)initWithAppointment:(Appointment *)appointment;

@end

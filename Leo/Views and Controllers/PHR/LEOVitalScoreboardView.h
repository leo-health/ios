//
//  LEOPHRVitalStatView.h
//  Leo
//
//  Created by Zachary Drossman on 7/5/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

@class PatientVitalMeasurement, Patient;

#import <UIKit/UIKit.h>

@interface LEOVitalScoreboardView : UIView

- (instancetype)initWithVital:(PatientVitalMeasurement *)vital forPatient:(Patient *)patient;


@end

//
//  LEORecordViewController.h
//  Leo
//
//  Created by Zachary Drossman on 5/26/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LEOPHRViewController, HealthRecord, PatientNote, Patient;

NS_ASSUME_NONNULL_BEGIN

typedef void(^EditNoteTouchedUpInsideBlock)(NSArray *notes);

@interface LEOPHRBodyView : UIView

@property (weak, nonatomic) LEOPHRViewController* phrViewController;
@property (strong, nonatomic) HealthRecord *healthRecord;
@property (strong, nonatomic) NSArray *notes;
@property (strong, nonatomic) Patient *patient;
@property (nonatomic) EditNoteTouchedUpInsideBlock editNoteTouchedUpInsideBlock;

- (void)reloadDataForPatient;

NS_ASSUME_NONNULL_END
@end

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
@property (copy, nonatomic) NSArray *notes;
@property (strong, nonatomic) Patient *patient;
@property (copy, nonatomic) EditNoteTouchedUpInsideBlock editNoteTouchedUpInsideBlock;
@property (copy, nonatomic) LEOVoidBlock loadShareableImmunizationsPDFBlock;

//This method should not be necessary in a world where the model informs the controllers that something has changed.
//It is a shortcut for now.
- (void)reloadDataForPatient;

NS_ASSUME_NONNULL_END
@end

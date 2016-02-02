//
//  LEORecordEditNotesViewController.h
//  Leo
//
//  Created by Adam Fanslau on 1/27/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientNote.h"
#import "Patient.h"

@interface LEORecordEditNotesViewController : UIViewController

@property (strong, nonatomic) Patient *patient;
@property (strong, nonatomic) PatientNote *note;
@property (nonatomic, copy) void (^editNoteCompletionBlock)(PatientNote *updatedNote);


@end

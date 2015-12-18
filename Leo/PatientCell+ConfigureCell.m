//
//  PatientCell+ConfigureCell.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/5/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "PatientCell+ConfigureCell.h"
#import "Patient.h"
#import "LEOMessagesAvatarImageFactory.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "LEOUserService.h"

@implementation PatientCell (ConfigureCell)


- (void)configureForPatient:(Patient *)patient {
    
    self.fullNameLabel.text = patient.fullName;
    self.fullNameLabel.font = [UIFont leo_menuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    self.fullNameLabel.textColor = [UIColor leo_grayForTitlesAndHeadings];
    
    if (patient.avatar) {
        self.avatarImageView.image = [LEOMessagesAvatarImageFactory circularAvatarImage:patient.avatar withDiameter:40 borderColor:[UIColor leo_grayForPlaceholdersAndLines] borderWidth:3];
        //This should really pull from the patient avatar image. But since we haven't set that up yet. This is a placeholder.
    } else {

        self.avatarImageView.image = [LEOMessagesAvatarImageFactory circularAvatarImage:[UIImage imageNamed:@"Icon-AvatarBorderless"] withDiameter:40 borderColor:[UIColor leo_grayForPlaceholdersAndLines] borderWidth:3];

        if (patient.avatarURL) {
            
            LEOUserService *userService = [[LEOUserService alloc] init];
            [userService getAvatarForUser:patient withCompletion:^(UIImage * rawImage, NSError * error) {
                
                if (!error) {
                  
                    UIImage *avatar;
                    if (!self.selected) {
                   
                        avatar = [LEOMessagesAvatarImageFactory circularAvatarImage:rawImage withDiameter:40 borderColor:[UIColor leo_grayForPlaceholdersAndLines] borderWidth:3];
                    } else {
                        avatar = [LEOMessagesAvatarImageFactory circularAvatarImage:rawImage withDiameter:40 borderColor:[UIColor leo_green] borderWidth:3];
                    }
                    
                    self.avatarImageView.image = avatar;
                    
                } else {
                    //deal with an error?
                }
            }];
        }
    }
}

@end

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

    UIImage *avatar;

    if (!self.selected) {

        avatar = [LEOMessagesAvatarImageFactory circularAvatarImage:patient.avatar.image withDiameter:40 borderColor:[UIColor leo_grayForPlaceholdersAndLines] borderWidth:3 renderingMode:UIImageRenderingModeAutomatic];
    } else {

        avatar = [LEOMessagesAvatarImageFactory circularAvatarImage:patient.avatar.image withDiameter:40 borderColor:[UIColor leo_green] borderWidth:3 renderingMode:UIImageRenderingModeAutomatic];
    }

    self.avatarImageView.image = avatar;
}

@end

//
//  LEOBasicHeaderCell+ConfigureForCell.m
//  Leo
//
//  Created by Zachary Drossman on 10/5/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOBasicHeaderCell+ConfigureForCell.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"

@implementation LEOBasicHeaderCell (ConfigureForCell)

/**
 *  Fills out the UITableViewCell with data provided by the controller.
 *
 *  @param patient       the patient to be displayed in the cell
 *  @param patientNumber an ordered number to determine whether to show the edit button
 */
- (void)configureWithTitle:(NSString *)title {
    
    self.headerLabel.text = title;

    [self setCopyFontAndColor];
}

- (void)setCopyFontAndColor {
    
    self.headerLabel.font = [UIFont leo_ultraLight27];
    self.headerLabel.textColor = [UIColor leo_grayForTitlesAndHeadings]; //MARK: This will have to be dynamic.
}


@end

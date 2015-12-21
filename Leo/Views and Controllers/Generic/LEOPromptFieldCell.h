//
//  LEOPromptFieldCell.h
//  Leo
//
//  Created by Zachary Drossman on 12/16/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOPromptField.h"

@interface LEOPromptFieldCell : UITableViewCell

@property (weak, nonatomic) IBOutlet LEOPromptField *promptField;

+(UINib *)nib;

@end

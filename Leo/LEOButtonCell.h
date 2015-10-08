//
//  LEOButtonCell.h
//  
//
//  Created by Zachary Drossman on 10/5/15.
//
//

#import <UIKit/UIKit.h>

@interface LEOButtonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *button;

+ (UINib *)nib;

@end
//
//  BasicSelectedCell.h
//  TableViewMeat
//
//  Created by Zachary Drossman on 6/8/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEODropDownSelectionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *checkListImageView;
@property (weak, nonatomic) IBOutlet UILabel *optionLabel;

+ (UINib *)nib;

@end

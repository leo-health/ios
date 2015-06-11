//
//  LEOExpandingListPickerView.h
//  Leo
//
//  Created by Zachary Drossman on 6/4/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEOExpandingListPickerView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *chosenOptionButton;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@end

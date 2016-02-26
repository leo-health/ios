//
//  LEOFeedHeaderCell.h
//  Leo
//
//  Created by Zachary Drossman on 2/23/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEOFeedHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *salutationLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

+ (UINib *)nib;


@end

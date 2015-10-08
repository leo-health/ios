//
//  LEOFeedTVC.h
//  Leo
//
//  Created by Zachary Drossman on 5/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardActivityProtocol.h"
#import "ExpandedCardViewProtocol.h"
#import "MenuView.h"

@interface LEOFeedTVC : UIViewController <UITableViewDelegate, UITableViewDataSource, CardActivityProtocol, ExpandedCardViewProtocol, MenuActivityProtocol>

@end

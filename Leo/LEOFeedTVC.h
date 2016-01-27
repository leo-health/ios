//
//  LEOFeedTVC.h
//  Leo
//
//  Created by Zachary Drossman on 5/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class Family;

#import <UIKit/UIKit.h>

#import "CardActivityProtocol.h"
#import "LEOExpandedCardViewProtocol.h"
#import "MenuView.h"
#import "LEOStickyHeaderViewController.h"

@interface LEOFeedTVC : UIViewController <UITableViewDelegate, UITableViewDataSource, CardActivityProtocol, LEOExpandedCardViewDelegate, MenuActivityProtocol>

@property (strong, nonatomic) Family *family;
@property (strong, nonatomic) NSString *cardInFocusObjectID;
@property (nonatomic) CardType cardInFocusType;

- (void)fetchData;


@end

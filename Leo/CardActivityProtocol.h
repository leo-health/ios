//
//  CardActivityDelegate.h
//  Leo
//
//  Created by Zachary Drossman on 6/10/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LEOCard;
@class Appointment;

#import "LEOCardProtocol.h"

@protocol CardActivityProtocol <NSObject>

- (void)didUpdateObjectStateForCard:(id<LEOCardProtocol>)card;

@end

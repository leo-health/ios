//
//  ProviderCell+ConfigureCell.h
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/5/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "ProviderCell.h"

@class Provider;

@interface ProviderCell (ConfigureCell)

- (void)configureForProvider:(Provider *)provider;

@end

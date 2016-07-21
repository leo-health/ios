//
//  LEOPromise.h
//  Leo
//
//  Created by Adam Fanslau on 6/29/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOPromise : NSObject

@property (nonatomic, getter=isExecuting) BOOL executing;
@property (nonatomic, getter=isFinished) BOOL finished;

+ (LEOPromise *)waitingForCompletion;
+ (LEOPromise *)finishedCompletion;

@end

//
//  LEOCardButton.m
//  Leo
//
//  Created by Zachary Drossman on 12/16/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOCardSubmissionControl.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"

@interface LEOCardSubmissionControl ()

@property (strong, nonatomic) CALayer *buttonLayer;
@end

@implementation LEOCardSubmissionControl

- (void)buttonTapped {

    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)isSubmissionReady:(BOOL)ready {

    if (ready) {
        [self setBackgroundColor:self.tintColor];
        [self.buttonLayer removeFromSuperlayer];
        self.enabled = YES;
    } else {
        [self setBackgroundColor:[UIColor leo_grayForMessageBubbles]];
        [self.layer addSublayer:self.buttonLayer];
        self.enabled = NO;
    }
}

-(CALayer *)buttonLayer {

    if (!_buttonLayer) {

        _buttonLayer = [CALayer layer];
        _buttonLayer.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, 1.0);
        _buttonLayer.borderColor = [UIColor leo_grayForPlaceholdersAndLines].CGColor;
        _buttonLayer.borderWidth = 1.0;
    }

    return _buttonLayer;
}
@end

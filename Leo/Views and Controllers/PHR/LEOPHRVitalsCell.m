//
//  LEOPHRVitalsCell.m
//  Leo
//
//  Created by Zachary Drossman on 4/7/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOPHRVitalsCell.h"
#import "LEOVitalGraphViewController.h"

@interface LEOPHRVitalsCell ()

@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end


@implementation LEOPHRVitalsCell

- (void)awakeFromNib {
}

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
}

- (void)setHostedGraphView:(UIView *)hostedGraphView {

    _hostedGraphView = hostedGraphView;

    [self.contentView addSubview:hostedGraphView];

    self.alreadyUpdatedConstraints = NO;
    [self setNeedsUpdateConstraints];
}

- (void)prepareForReuse {
    
    [super prepareForReuse];

    self.hostedGraphView = nil;
}

- (void)updateConstraints {

    if (!self.alreadyUpdatedConstraints) {

        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        self.hostedGraphView.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *bindings = NSDictionaryOfVariableBindings(_hostedGraphView);

        NSArray *horizontalLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_hostedGraphView(==375)]|" options:0 metrics:nil views:bindings];

        NSArray *verticalLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_hostedGraphView(==200)]|" options:0 metrics:nil views:bindings];

        [self.contentView addConstraints:horizontalLayoutConstraints];
        [self.contentView addConstraints:verticalLayoutConstraints];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateConstraints];
}

@end

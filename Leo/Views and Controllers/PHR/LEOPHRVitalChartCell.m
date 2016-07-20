//
//  LEOPHRVitalChartCell.m
//  Leo
//
//  Created by Zachary Drossman on 4/7/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOPHRVitalChartCell.h"
#import "LEOVitalGraphViewController.h"
#import "LEODevice.h"

@interface LEOPHRVitalChartCell ()

@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end


@implementation LEOPHRVitalChartCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setHostedGraphView:(UIView *)hostedGraphView {

    _hostedGraphView = hostedGraphView;

    [self.contentView addSubview:hostedGraphView];

    self.alreadyUpdatedConstraints = NO;
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {

    if (!self.alreadyUpdatedConstraints) {

        self.hostedGraphView.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *bindings = NSDictionaryOfVariableBindings(_hostedGraphView);

        NSDictionary *metrics = @{@"width" : [self chartWidthMetric],
                                  @"height" : [self chartHeightMetric]};

        NSArray *horizontalLayoutConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_hostedGraphView(width)]|"
                                                options:0
                                                metrics:metrics
                                                  views:bindings];

        NSArray *verticalLayoutConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_hostedGraphView(height)]|"
                                                options:0
                                                metrics:metrics
                                                  views:bindings];

        [self.contentView addConstraints:horizontalLayoutConstraints];
        [self.contentView addConstraints:verticalLayoutConstraints];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateConstraints];
}

- (NSNumber *)chartWidthMetric {

    switch ([LEODevice deviceModel]) {

        case DeviceModel4OrLess:
            return @320;

        case DeviceModel5:
            return @320;

        case DeviceModel6:
            return @375;

        case DeviceModel6Plus:
            return @414;

        case DeviceModelUnsupported:
            return @320;
    }
}

- (NSNumber *)chartHeightMetric {

    switch ([LEODevice deviceModel]) {
            
        case DeviceModel5:
            return @260;

        case DeviceModel6:
            return @260;

        case DeviceModel6Plus:
            return @260;

        case DeviceModelUnsupported:
            return @260;

        default:
            return @260;
    }
}

@end

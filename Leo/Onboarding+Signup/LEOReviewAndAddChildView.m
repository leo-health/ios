//
//  LEOReviewAndAddChildView.m
//  Leo
//
//  Created by Zachary Drossman on 9/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOReviewAndAddChildView.h"

@interface LEOReviewAndAddChildView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintForTableView;

@end

@implementation LEOReviewAndAddChildView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setupConstraintsWithCellCount:0];
        [self setupTableView];

    }
    
    return self;
}

-(instancetype)initWithCellCount:(NSInteger)cellCount {
    
    self = [super init];
    
    if (self) {
        
        [self setupConstraintsWithCellCount:cellCount];
        [self setupTableView];
    }
    
    return self;
}


#pragma mark - Autolayout

- (void)setupConstraintsWithCellCount:(NSInteger)cellCount {
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *loadedViews = [mainBundle loadNibNamed:@"LEOReviewAndAddChildView" owner:self options:nil];
    LEOReviewAndAddChildView *loadedSubview = [loadedViews firstObject];
    
    [self addSubview:loadedSubview];
    
    loadedSubview.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeTop]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeLeft]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeBottom]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeRight]];
    
    self.heightConstraintForTableView.constant = cellCount * 68;
}

- (NSLayoutConstraint *)pin:(id)item attribute:(NSLayoutAttribute)attribute {
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:item
                                        attribute:attribute
                                       multiplier:1.0
                                         constant:0.0];
}

- (void)setupTableView {
    
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
@end

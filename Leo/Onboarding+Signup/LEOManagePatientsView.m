//
//  LEOManagePatientsView.m
//  Leo
//
//  Created by Zachary Drossman on 9/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOManagePatientsView.h"

@interface LEOManagePatientsView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintForTableView;

@end

@implementation LEOManagePatientsView

-(instancetype)initWithCellCount:(NSInteger)cellCount {
    
    self = [super init];
    
    if (self) {
        
        _cellCount = cellCount;
        
        [self setupConstraints];
        [self setupTableView];
    }
    
    return self;
}

#pragma mark - Autolayout

- (void)setupConstraints {
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *loadedViews = [mainBundle loadNibNamed:@"LEOManagePatientsView" owner:self options:nil];
    LEOManagePatientsView *loadedSubview = [loadedViews firstObject];
    
    [self addSubview:loadedSubview];
    
    loadedSubview.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeTop]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeLeft]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeBottom]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeRight]];
    
    self.heightConstraintForTableView.constant = self.cellCount * 68;
    
    [self addConstraint:self.heightConstraintForTableView];
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

-(NSLayoutConstraint *)heightConstraintForTableView {
    
    if (!_heightConstraintForTableView) {
        _heightConstraintForTableView = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.cellCount * 68];
    }
    
    return _heightConstraintForTableView;
}

-(void)setCellCount:(NSInteger)cellCount {
    _cellCount = cellCount;
    
    [self updateHeightForTableView];
}

- (void)updateHeightForTableView {
    
    [self removeConstraint:self.heightConstraintForTableView];
    
    self.heightConstraintForTableView.constant =  self.cellCount * 68;
    
    [self addConstraint:self.heightConstraintForTableView];
}
- (void)setupTableView {
    
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
@end

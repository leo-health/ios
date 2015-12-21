//
//  LEOStickyHeaderViewController.m
//  Leo
//
//  Created by Zachary Drossman on 11/23/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOStickyHeaderViewController.h"
#import "UIColor+LeoColors.h"
#import "LEOStyleHelper.h"
#import "LEOStickyHeaderView.h"
@interface LEOStickyHeaderViewController ()

@property (nonatomic) Feature feature;
@property (strong, nonatomic) UILabel *expandedTitleLabel;

@property (strong, nonatomic) LEOStickyHeaderView *stickyHeaderView;

@end

@implementation LEOStickyHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupHeader];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)injectBodyView {
    return [[UIView alloc] init];
}

- (void)setupHeader {
    
    //Setup navigation bar itself
    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:self.feature withTitleText:self.card.title dismissal:YES backButton:NO];
    
    //TODO: This should come out most likely since it's part of the stickyheaderview and not controller...
    //Setup when in expanded state
    [LEOStyleHelper styleExpandedTitleLabel:self.expandedTitleLabel titleText:self.card.title];
}







@end

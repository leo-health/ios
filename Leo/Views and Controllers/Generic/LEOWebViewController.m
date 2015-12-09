//
//  LEOWebViewController.m
//  Leo
//
//  Created by Zachary Drossman on 11/19/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

@import WebKit;

#import "LEOWebViewController.h"
#import "LEOStyleHelper.h"


@interface LEOWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LEOWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [LEOApiReachability startMonitoringForController:self];

    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    
    [self setupNavigationBar];
}

- (void)setupNavigationBar {
    
    [LEOStyleHelper styleNavigationBarForFeature:self.feature];
    [LEOStyleHelper styleBackButtonForViewController:self forFeature:self.feature];
    
    UILabel *navigationLabel = [UILabel new];
    navigationLabel.text = self.titleString;
    
    [LEOStyleHelper styleLabel:navigationLabel forFeature:self.feature];
    
    self.navigationItem.titleView = navigationLabel;
}

- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end

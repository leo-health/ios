//
//  LEOWebViewController.m
//  Leo
//
//  Created by Zachary Drossman on 11/19/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

@import WebKit;

#import "LEOWebViewController.h"



@interface LEOWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LEOWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

@end

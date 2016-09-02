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
#import <MBProgressHUD/MBProgressHUD.h>
#import "LEOAnalytic.h"
#import "NSDate+Extensions.h"

@interface LEOWebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) UIWebView *webView;
@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end

@implementation LEOWebViewController

- (UIWebView *)webView {

    if (!_webView) {

        UIWebView *strongWebView = [UIWebView new];

        _webView = strongWebView;

        [self.view addSubview:_webView];

        _webView.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *bindings = NSDictionaryOfVariableBindings(_webView);

        NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_webView]|" options:0 metrics:nil views:bindings];

        NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_webView]|" options:0 metrics:nil views:bindings];

        [self.view addConstraints:horizontalConstraints];
        [self.view addConstraints:verticalConstraints];
    }

    return _webView;
}

- (void)viewDidLoad {

    [super viewDidLoad];

    self.webView.delegate = self;

    [self setupNavigationBar];

    if (self.shareData) {

        [self.webView loadData:self.shareData
                      MIMEType:@"Application/PDF"
              textEncodingName:@"UTF-8"
                       baseURL:nil];
    } else {

        NSURL *url = [NSURL URLWithString:self.urlString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:urlRequest];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    [LEOAnalytic tagType:LEOAnalyticTypeScreen
                    name:self.titleString];

    [LEOApiReachability startMonitoringForController:self];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (!_shareData) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self finishLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self finishLoading];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishLoading {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)setupNavigationBar {

    if ([self isModal]) {

        [LEOStyleHelper styleNavigationBarForViewController:self forFeature:self.feature withTitleText:@"Share Preview" dismissal:YES backButton:NO];
    } else {

        [LEOStyleHelper styleNavigationBarForViewController:self forFeature:self.feature withTitleText:@"Share Preview" dismissal:NO backButton:YES];
    }

    UILabel *navigationLabel = [UILabel new];
    navigationLabel.text = self.titleString;

    [LEOStyleHelper styleLabel:navigationLabel forFeature:self.feature];

    self.navigationItem.titleView = navigationLabel;

    if (self.shareData) {
        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                        target:self
                                        action:@selector(share)];
        shareButton.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = shareButton;
    }
}

- (void)share {

    MFMailComposeViewController *mailVC = [self configureMailComposeViewController];

    [self presentViewController:mailVC
                       animated:YES
                     completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

    [[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (MFMailComposeViewController *)configureMailComposeViewController {

    [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];

    MFMailComposeViewController *mailVC = [MFMailComposeViewController new];

    mailVC.mailComposeDelegate = self;
    [mailVC addAttachmentData:self.shareData mimeType:@"application/pdf" fileName:@"immunization_record"];
    [mailVC setSubject:self.shareSubject];
    [mailVC setMessageBody:self.shareBody isHTML:NO];

    return mailVC;
}


//Source: http://stackoverflow.com/questions/23620276/check-if-view-controller-is-presented-modally-or-pushed-on-a-navigation-stack
- (BOOL)isModal {
    if([self presentingViewController])
        return YES;
    if([[self presentingViewController] presentedViewController] == self)
        return YES;
    if([[[self navigationController] presentingViewController] presentedViewController] == [self navigationController])
        return YES;
    if([[[self tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]])
        return YES;

    return NO;
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

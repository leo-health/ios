//
//  LEOConversationFullScreenNoticeViewController.m
//  Leo
//
//  Created by Zachary Drossman on 4/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOConversationFullScreenNoticeViewController.h"
#import "LEOConversationFullScreenNoticeView.h"

@interface LEOConversationFullScreenNoticeViewController ()

@property (weak, nonatomic) LEOConversationFullScreenNoticeView *noticeView;

@end

@implementation LEOConversationFullScreenNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (LEOConversationFullScreenNoticeView *)noticeView {

    if (!_noticeView) {

        __weak typeof(self) weakSelf = self;

        void (^noticeButtonOneTouchedUpInsideBlock)(void) = ^(void) {
            [self.presentedViewController.view removeFromSuperview];
        };

        void (^noticeButtonTwoTouchedUpInsideBlock)(void) = ^(void) {

            NSString *phoneCallNum = [NSString stringWithFormat:@"tel://%@",kFlatironPediatricsPhoneNumber];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneCallNum]];
        };

        void (^dismissButtonTouchedUpInsideBlock)(void) = ^(void) {

            __strong typeof(self) strongSelf = weakSelf;

            [strongSelf dismissViewControllerAnimated:YES completion:nil];
        };


        NSString *headerString = @"Our office is closed at the moment.";
        NSString *bodyString = @"Please call 911 in case of emergency. If you need clinical assistance now, you can call our nurse line.";

        LEOConversationFullScreenNoticeView *strongView = [[LEOConversationFullScreenNoticeView alloc] initWithHeaderText:headerString
                                                                                                                 bodyText:bodyString
                                                                                            buttonOneTouchedUpInsideBlock:noticeButtonOneTouchedUpInsideBlock
                                                                                            buttonTwoTouchedUpInsideBlock:noticeButtonTwoTouchedUpInsideBlock
                                                                                        dismissButtonTouchedUpInsideBlock:dismissButtonTouchedUpInsideBlock];
        _noticeView = strongView;

        [self.view addSubview:_noticeView];
    }

    return _noticeView;
}

- (void)updateViewConstraints {

    self.noticeView.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *bindings = NSDictionaryOfVariableBindings(_noticeView);

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_noticeView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:bindings]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_noticeView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:bindings]];

    [super updateViewConstraints];
}


@end

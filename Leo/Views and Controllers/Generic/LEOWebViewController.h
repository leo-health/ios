//
//  LEOWebViewController.h
//  Leo
//
//  Created by Zachary Drossman on 11/19/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MessageUI;

@interface LEOWebViewController : UIViewController <MFMailComposeViewControllerDelegate>
NS_ASSUME_NONNULL_BEGIN

@property (copy, nonatomic) NSString *urlString;
@property (copy, nonatomic) NSString *titleString;
@property (nonatomic) Feature feature;
@property (strong, nonatomic) NSData* shareData;
@property (copy, nonatomic) NSString *shareSubject;
@property (copy, nonatomic) NSString *shareAttachmentName;
@property (copy, nonatomic) NSString *shareBody;

NS_ASSUME_NONNULL_END
@end

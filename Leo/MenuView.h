//
//  MenuView.h
//  Leo
//
//  Created by Zachary Drossman on 6/23/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuActivityProtocol <NSObject>

- (void)beginBookingNewAppointment;
- (void)beginUploadingNewForm;
- (void)loadContactUsView;
- (void)loadSettingsView;
- (void)didMakeMenuChoice;

@end

@interface MenuView : UIView

@property (weak, nonatomic) id<MenuActivityProtocol>delegate;

@end

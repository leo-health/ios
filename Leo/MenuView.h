//
//  MenuView.h
//  Leo
//
//  Created by Zachary Drossman on 6/23/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MenuChoice) {
    
    MenuChoiceUndefined,
    MenuChoiceScheduleAppointment,
    MenuChoiceChat,
    MenuChoiceSubmitAForm,
    MenuChoiceUpdateSettings,
};

@protocol MenuActivityProtocol <NSObject>

- (void)didMakeMenuChoice:(MenuChoice)menuChoice;

@end

@interface MenuView : UIView

@property (weak, nonatomic) id<MenuActivityProtocol>delegate;

@end

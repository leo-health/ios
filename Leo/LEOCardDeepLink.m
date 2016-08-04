//
//  LEOCardDeepLink.m
//  Leo
//
//  Created by Adam Fanslau on 8/4/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOCardDeepLink.h"
#import "Leo-Swift.h"
#import "UIImage+Extensions.h"
#import "LEOFormatting.h"
#import "NSDictionary+Extensions.h"
#import "LEOCardService.h"

@implementation LEOCardDeepLink

@synthesize dismissButtonText = _dismissButtonText;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {

    NSString *objectID = [jsonResponse leo_itemForKey:APIParamID];
    NSNumber *priority = [jsonResponse leo_itemForKey:APIParamCardPriority];

    NSDictionary *json = [jsonResponse leo_itemForKey:APIParamCardData];

    self = [super initWithObjectID:objectID
                          priority:priority
                              type:CardTypeCustom
              associatedCardObject:nil];

    if (self) {
        
        _tintColorHex = [json leo_itemForKey:@"tint_color_hex"];
        _tintedHeaderText = [json leo_itemForKey:@"tinted_header_text"];
        _title = [json leo_itemForKey:@"title"];
        _body = [json leo_itemForKey:@"body"];

        NSDictionary *iconJSON = [json leo_itemForKey:@"icon"];
        _iconImage = [[LEOS3Image alloc] initWithJSONDictionary:iconJSON];

        _dismissButtonText = [json leo_itemForKey:@"dismiss_button_text"];
        _deepLinkButtonText = [json leo_itemForKey:@"deep_link_button_text"];
        _tintedHeaderText = [json leo_itemForKey:@"tinted_header_text"];
        _deepLink = [json leo_itemForKey:@"deep_link"];
    }

    [self setupNotifications];

    return self;
}

- (NSString *)dismissButtonText {

    if (!_dismissButtonText) {
        _dismissButtonText = @"Dismiss";
    }

    return _dismissButtonText;
}


# pragma mark  -  LEOCardProtocol

- (UIImage *)icon {
    return self.iconImage.image;
}

- (UIColor *)tintColor {
    return [[UIColor alloc] initWithHex:self.tintColorHex alpha:1];
}

- (NSArray *)stringRepresentationOfActionsAvailableForState {

    NSMutableArray *actions = [NSMutableArray new];
    if (self.deepLinkButtonText) {
        [actions addObject:self.deepLinkButtonText];
    }
    [actions addObject:self.dismissButtonText];

    return [actions copy];
}

- (NSArray *)actionsAvailableForState {

    NSMutableArray *actions = [NSMutableArray new];
    if (self.deepLinkButtonText) {
        [actions addObject:NSStringFromSelector(@selector(routeToURL))];
    }

    [actions addObject:NSStringFromSelector(@selector(dismiss))];
    return [actions copy];
}

- (id)targetForState {
    return self;
}

- (CardConfiguration)configuration {

    if (self.deepLinkButtonText && self.dismissButtonText) {
        return CardConfigurationTwoButtonHeaderOnly;
    } else {
        return CardConfigurationOneButtonHeaderOnly;
    }
}

- (void)setupNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateForDownloadedImage)
                                                 name:kNotificationDownloadedImageUpdated
                                               object:self.iconImage];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateForChangedImage)
                                                 name:kNotificationImageChanged
                                               object:self.iconImage];
}

- (void)removeObservers {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNotificationDownloadedImageUpdated
                                                  object:self.iconImage];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNotificationImageChanged
                                                  object:self.iconImage];
}

- (void)dealloc {
    [self removeObservers];
}

- (void)updateForDownloadedImage {
    [self.activityDelegate didUpdateObjectStateForCard:self];
}

- (void)updateForChangedImage {
    [self.activityDelegate didUpdateObjectStateForCard:self];
}


- (void)routeToURL {

    NSURL *url = [NSURL URLWithString:self.deepLink];
    if (!url) {
        return;
    }

    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        return;
    }

    [[UIApplication sharedApplication] openURL:url];
}

- (void)dismiss {

    [[LEOCardService new] deleteCardWithID:self.objectID completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStatusChanged object:self];

    self.wasDismissed = YES;
    [self.activityDelegate didUpdateObjectStateForCard:self];
}




@end

//
//  LEOCardDeepLink.h
//  Leo
//
//  Created by Adam Fanslau on 8/4/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOCard.h"

@class LEOS3Image;

@interface LEOCardDeepLink : LEOCard<LEOCardProtocol> // <LEOJSONSerializable> multiple inheritence FTW... someday

@property (copy, nonatomic, readonly) NSString *tintColorHex;
@property (copy, nonatomic, readonly) NSString *tintedHeaderText;
@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly) NSString *body;
@property (strong, nonatomic, readonly) LEOS3Image *iconImage;
@property (copy, nonatomic, readonly) NSString *dismissButtonText;
@property (copy, nonatomic, readonly) NSString *deepLinkButtonText;
@property (copy, nonatomic, readonly) NSString *deepLink;
@property (copy, nonatomic, readonly) NSString *category;

@property (nonatomic) BOOL wasDismissed;

@end

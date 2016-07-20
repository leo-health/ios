//
//  Notice.h
//  Leo
//
//  Created by Zachary Drossman on 4/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOJSONSerializable.h"

@interface Notice : LEOJSONSerializable
NS_ASSUME_NONNULL_BEGIN

//TODO: This object should be made to provide full details of a notice, including UIImage or UIImage reference if stored locally, and, if a hypermedia API, the "link" to the appropriate screen within the app.

@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *headerText;
@property (copy, nonatomic, readonly) NSString *bodyText;
@property (copy, nonatomic, readonly) NSDictionary *headerAttributes;
@property (copy, nonatomic, readonly) NSDictionary *bodyAttributes;
@property (nonatomic) BOOL actionAvailable;

NS_ASSUME_NONNULL_END
@end

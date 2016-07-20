//
//  LEOS3Image.h
//  Leo
//
//  Created by Zachary Drossman on 1/14/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOJSONSerializable.h"

@interface LEOS3Image : LEOJSONSerializable <NSCopying>

@property (copy, nonatomic) NSString *baseURL;
@property (copy, nonatomic) NSDictionary *parameters;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *underlyingImage;
@property (strong, nonatomic) UIImage *placeholder;
@property (strong, nonatomic) NSURLSessionDataTask *downloadTask;
@property (nonatomic, readonly) BOOL isPlaceholder;

- (instancetype)initWithBaseURL:(NSString *)baseURL
                     parameters:(NSDictionary *)parameters
                    placeholder:(UIImage *)placeholder
                          image:(UIImage *)image;

- (instancetype)initWithBaseURL:(NSString *)baseURL
                     parameters:(NSDictionary *)parameters
                    placeholder:(UIImage *)placeholder;

- (void)setNeedsRefresh;
- (void)refreshIfNeeded;

+ (UIImage *)resizeLocalAvatarImageBasedOnScreenScale:(UIImage *)avatarImage;

@end

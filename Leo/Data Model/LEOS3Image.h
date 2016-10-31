//
//  LEOS3Image.h
//  Leo
//
//  Created by Zachary Drossman on 1/14/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

@class LEOPromise;

#import <Foundation/Foundation.h>
#import "LEOJSONSerializable.h"
#import "LEOCachePolicy.h"


@interface LEOS3Image : LEOJSONSerializable <NSCopying>

@property (strong, nonatomic) LEOCachePolicy *cachePolicy;
@property (copy, nonatomic) NSString *baseURL;
@property (copy, nonatomic) NSDictionary *parameters;
@property (nonatomic) BOOL nonClinical;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *underlyingImage;
@property (strong, nonatomic) UIImage *placeholder;
@property (strong, nonatomic) LEOPromise *downloadPromise;
@property (nonatomic, readonly) BOOL isPlaceholder;

- (instancetype)initWithBaseURL:(NSString *)baseURL
                     parameters:(NSDictionary *)parameters
                    placeholder:(UIImage *)placeholder
                          image:(UIImage *)image
                    nonClinical:(BOOL)nonClinical;

- (instancetype)initWithBaseURL:(NSString *)baseURL
                     parameters:(NSDictionary *)parameters
                    placeholder:(UIImage *)placeholder
                    nonClinical:(BOOL)nonClinical;

- (void)setNeedsRefresh;
- (LEOPromise *)refreshIfNeeded;

- (void)refreshWithCachedImage;

+ (UIImage *)resizeLocalAvatarImageBasedOnScreenScale:(UIImage *)avatarImage;

@end

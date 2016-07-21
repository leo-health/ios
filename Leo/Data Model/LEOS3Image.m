//
//  LEOS3Image.m
//  Leo
//
//  Created by Zachary Drossman on 1/14/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOS3Image.h"
#import "LEOMediaService.h"
#import <UIImage-Resize/UIImage+Resize.h>
#import "NSDictionary+Extensions.h"

@implementation LEOS3Image

static CGFloat kImageSideSizeScale1Avatar = 100.0;
static CGFloat kImageSideSizeScale2Avatar = 200.0;
static CGFloat kImageSideSizeScale3Avatar = 300.0;

- (instancetype)initWithBaseURL:(NSString *)baseURL parameters:(NSDictionary *)parameters placeholder:(UIImage *)placeholder image:(UIImage *)image {

    self = [super init];
    if (self) {

        _baseURL = [baseURL copy];
        _parameters = [parameters copy];
        _placeholder = placeholder;
        _underlyingImage = image;
    }
    return self;
}

- (instancetype)initWithBaseURL:(NSString *)baseURL parameters:(NSDictionary *)parameters placeholder:(UIImage *)placeholder {
    
    return [self initWithBaseURL:baseURL parameters:parameters placeholder:placeholder image:nil];
}

-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {

    if (!jsonDictionary) {
        return nil;
    }

    NSString *baseURL = [jsonDictionary leo_itemForKey:APIParamImageBaseURL];
    NSDictionary *parameters = [jsonDictionary leo_itemForKey:APIParamImageURLParameters];

    UIImage *image = [jsonDictionary leo_itemForKey:@"image"];
    UIImage *placeholder = [jsonDictionary leo_itemForKey:@"placeholder"];

    return [self initWithBaseURL:baseURL parameters:parameters placeholder:placeholder image:image];
}

- (UIImage *)image {

    [self refreshIfNeeded];

    if (!self.underlyingImage) {
        return self.placeholder;
    }
    return self.underlyingImage;
}

+ (NSDictionary *)serializeToJSON:(LEOS3Image *)image {

    NSMutableDictionary *jsonDictionary = [NSMutableDictionary new];
    jsonDictionary[APIParamImageBaseURL] = image.baseURL;
    jsonDictionary[APIParamImageURLParameters] = image.parameters;

    jsonDictionary[@"image"] = image.underlyingImage;
    jsonDictionary[@"placeholder"] = image.placeholder;

    return [jsonDictionary copy];
}

- (BOOL)isPlaceholder {

    return !self.underlyingImage;
}

- (void)setNeedsRefresh {
    self.underlyingImage = nil;
}

- (void)refreshIfNeeded {

    if (!self.underlyingImage && self.baseURL && !self.downloadTask) {

        __weak typeof(self) weakSelf = self;
        self.downloadTask = [[LEOMediaService new] getImageForS3Image:self withCompletion:^(UIImage * rawImage, NSError * error) {
            __strong typeof(self) strongSelf = weakSelf;
            if (!error && rawImage) {

                strongSelf.underlyingImage = rawImage;
                strongSelf.downloadTask = nil;

                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDownloadedImageUpdated object:strongSelf];
            }
        }];
    }
}

-(void)setImage:(UIImage *)image {

    self.underlyingImage = image;

    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationImageChanged object:self];
}

- (id)copyWithZone:(NSZone *)zone {

    LEOS3Image *s3Copy = [[LEOS3Image allocWithZone:zone] initWithBaseURL:[self.baseURL copy] parameters:[self.parameters copy] placeholder:[self.placeholder copy]];

    if (self.underlyingImage) {
        s3Copy.underlyingImage = [self.underlyingImage copy];
    }
    
    return s3Copy;
}

+ (UIImage *)resizeLocalAvatarImageBasedOnScreenScale:(UIImage *)avatarImage {

    CGFloat resizedImageSideSize = kImageSideSizeScale3Avatar;

    NSInteger scale = (int)[UIScreen mainScreen].scale;

    switch (scale) {

        case 1:
            resizedImageSideSize = kImageSideSizeScale1Avatar;
            break;

        case 2:
            resizedImageSideSize = kImageSideSizeScale2Avatar;
            break;

        case 3:
            resizedImageSideSize = kImageSideSizeScale3Avatar;
            break;
    }

    return [avatarImage resizedImageToSize:CGSizeMake(resizedImageSideSize, resizedImageSideSize)];
}


@end

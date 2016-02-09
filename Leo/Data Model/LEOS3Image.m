//
//  LEOS3Image.m
//  Leo
//
//  Created by Zachary Drossman on 1/14/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOS3Image.h"
#import "LEOMediaService.h"

@implementation LEOS3Image

@synthesize image = _image;

- (instancetype)initWithBaseURL:(NSString *)baseURL parameters:(NSDictionary *)parameters placeholder:(UIImage *)placeholder {

    self = [super init];

    if (self) {

        _baseURL = [baseURL copy];
        _parameters = [parameters copy];
        _placeholder = placeholder;
    }

    return self;
}

-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {

    NSString *baseURL = jsonResponse[APIParamImageBaseURL];
    NSDictionary *parameters = jsonResponse[APIParamImageURLParameters];

    return [self initWithBaseURL:baseURL parameters:parameters placeholder:nil];
}

- (UIImage *)image {

    if (!_image) {

        _image = self.placeholder;

        LEOMediaService *mediaService = [LEOMediaService new];

        [mediaService getImageForS3Image:self withCompletion:^(UIImage * rawImage, NSError * error) {

            if (!error && rawImage) {

                _image = rawImage;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDownloadedImageUpdated object:self];
            } else {

                //TODO: Consider whether this is ultimately the right implementation.
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationImageChanged object:self];
            }
        }];
    }

    return _image;
}

-(void)setImage:(UIImage *)image {

    _image = image;

    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationImageChanged object:self];
}

- (id)copyWithZone:(NSZone *)zone {

    LEOS3Image *s3Copy = [[LEOS3Image allocWithZone:zone] initWithBaseURL:[self.baseURL copy] parameters:[self.parameters copy] placeholder:[self.placeholder copy]];

    if (self.image) {
        s3Copy.image = [self.image copy];
    }
    
    return s3Copy;
}

@end

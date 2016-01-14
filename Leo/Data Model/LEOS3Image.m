//
//  LEOS3Image.m
//  Leo
//
//  Created by Zachary Drossman on 1/14/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOS3Image.h"
#import "LEOUserService.h"

@implementation LEOS3Image


- (instancetype)initWithBaseURL:(NSString *)baseURL parameters:(NSDictionary *)parameters{

    self = [super init];

    if (self) {

        _baseURL = [baseURL copy];
        _parameters = [parameters copy];
    }

    return self;
}

-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {

    NSString *baseURL = jsonResponse[APIParamImageBaseURL];
    NSDictionary *parameters = jsonResponse[APIParamImageURLParameters];

    return [self initWithBaseURL:baseURL parameters:parameters];
}

- (void)getS3ImageDataForS3ImageWithCompletion:(void (^) (void))completion {

    LEOUserService *userService = [LEOUserService new];

    [userService getImageForS3Image:self withCompletion:^(UIImage * rawImage, NSError * error) {

        if (!error && rawImage) {

            self.image = rawImage;

            if (completion) {
                completion();
            }
        } else {
            //TODO: ZSD deal with an error?
        }
    }];
}

- (id)copyWithZone:(NSZone *)zone {

    LEOS3Image *s3Copy = [self initWithBaseURL:[self.baseURL copy] parameters:[self.parameters copy]];
    s3Copy.image = [self.image copy];
    
    return s3Copy;
}

@end

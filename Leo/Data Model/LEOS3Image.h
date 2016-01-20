//
//  LEOS3Image.h
//  Leo
//
//  Created by Zachary Drossman on 1/14/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOS3Image : NSObject <NSCopying>

@property (copy, nonatomic) NSString *baseURL;
@property (copy, nonatomic) NSDictionary *parameters;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *placeholder;

- (instancetype)initWithBaseURL:(NSString *)baseURL parameters:(NSDictionary *)parameters placeholder:(UIImage *)placeholder;
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;
- (void)getS3ImageDataForS3ImageWithCompletion:(void (^) (void))completion;

//"X-Amz-Algorithm" = "AWS4-HMAC-SHA256";
//"X-Amz-Credential" = "AKIAIZJEJH6F6OQL43XQ/20160114/us-east-1/s3/aws4_request";
//"X-Amz-Date" = 20160114T160124Z;
//"X-Amz-Expires" = 900;
//"X-Amz-Signature" = 3e39b7816676e14c3d76efd182731c0681f8226357ec85ca88b7f7c4849dd784;
//"X-Amz-SignedHeaders" = host;
//"base_url" = "https://leo-photos-development.s3.amazonaws.com";
@end

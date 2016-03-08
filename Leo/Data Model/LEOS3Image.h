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
@property (nonatomic, readonly) BOOL isPlaceholder;

/**
 *  Returns YES if an image other than the placeholder is expected to exist, i.e if baseURL or the user manually sets the image
 */
@property (nonatomic, readonly) BOOL hasImagePromise;

- (instancetype)initWithBaseURL:(NSString *)baseURL parameters:(NSDictionary *)parameters placeholder:(UIImage *)placeholder;
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;
- (void)getS3ImageDataForS3ImageWithCompletion:(void (^) (void))completion;

- (void)setNeedsRefresh;
- (void)refreshIfNeeded;

@end

//
//  Notice.h
//  Leo
//
//  Created by Zachary Drossman on 4/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notice : NSObject
NS_ASSUME_NONNULL_BEGIN

//TODO: This object should be made to provide full details of a notice, including UIImage or UIImage reference if stored locally, and, if a hypermedia API, the "link" to the appropriate screen within the app.

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSAttributedString *attributedHeaderText;
@property (copy, nonatomic) NSAttributedString *attributedBodyText;
@property (nonatomic) BOOL actionAvailable;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary;
- (instancetype)initWithName:(NSString *)name attributedHeaderText:(NSAttributedString *)attributedHeaderString attributedBodyText:(NSAttributedString *)attributedBodyString actionAvailable:(BOOL)actionAvailable;
- (instancetype)initWithName:(NSString *)name headerText:(NSString *)headerString bodyText:(NSString *)bodyString actionAvailable:(BOOL)actionAvailable;

+ (NSArray *)noticesFromJSONArray:(NSArray *)jsonResponse;


NS_ASSUME_NONNULL_END
@end

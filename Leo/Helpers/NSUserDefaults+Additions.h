//
//  NSUserDefaults+Additions.h
//  
//
//  Created by Zachary Drossman on 11/12/15.
//
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Additions)

+ (void)loadDefaultsWithName:(NSString *)name;
+ (void)loadDefaultsWithDictionary:(NSDictionary *)dictionary;

+ (void)removeAllDefaults;

+ (NSString *)stringForKey:(NSString *)defaultName;
+ (void)setString:(NSString *)value forKey:(NSString *)defaultName;

+ (NSInteger)integerForKey:(NSString *)defaultName;
+ (CGFloat)floatForKey:(NSString *)defaultName;
+ (BOOL)boolForKey:(NSString *)defaultName;

@end

//
//  NSUserDefaults+Extensions.h
//  
//
//  Created by Zachary Drossman on 11/12/15.
//
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Extensions)

+ (void)leo_loadDefaultsWithName:(NSString *)name;
+ (void)leo_loadDefaultsWithDictionary:(NSDictionary *)dictionary;

+ (void)leo_saveDefaults;
+ (void)leo_removeAllDefaults;
+ (void)leo_removeObjectForKey:(NSString *)defaultName;

+ (NSString *)leo_stringForKey:(NSString *)defaultName;
+ (void)leo_setString:(NSString *)value forKey:(NSString *)defaultName;

+ (NSInteger)leo_integerForKey:(NSString *)defaultName;
+ (CGFloat)leo_floatForKey:(NSString *)defaultName;
+ (BOOL)leo_boolForKey:(NSString *)defaultName;

@end

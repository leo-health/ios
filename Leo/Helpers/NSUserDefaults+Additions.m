//
//  NSUserDefaults+Additions.m
//  
//
//  Created by Zachary Drossman on 11/12/15.
//
//

#import "NSUserDefaults+Additions.h"

@implementation NSUserDefaults (Additions)

static NSUserDefaults *defaults;

+ (void)loadDefaultsWithName:(NSString *)name {

    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    [self loadDefaultsWithDictionary:dictionary];
}

+ (void)loadDefaultsWithDictionary:(NSDictionary *)dictionary {
    
    if (!defaults) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    
    [defaults registerDefaults:dictionary];
    
    static NSString * const versionKey = @"Version";
    
    if (![defaults objectForKey:versionKey]) {
        // First-time launch store all values from defaults into system for editing
        for (NSString *key in dictionary)
            [defaults setObject:[dictionary objectForKey:key] forKey:key];
    }
    
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:
                            (NSString *)kCFBundleVersionKey];
    NSString *defaultsVersion = [defaults objectForKey:versionKey];
   
    if (![defaultsVersion isEqual:appVersion]) {
        [NSUserDefaults removeAllDefaults];
    }
    
    [defaults setObject:appVersion forKey:versionKey];
    [defaults synchronize];
}

+ (void)removeAllDefaults {
    
    NSString *domainName = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domainName];
}

+ (NSString *)stringForKey:(NSString *)defaultName {
    
    if (!defaults) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    return [defaults stringForKey:defaultName];
}

+ (void)setString:(NSString *)value forKey:(NSString *)defaultName {
    
    if (!defaults) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    [defaults setObject:value forKey:defaultName];
}

+ (NSInteger)integerForKey:(NSString *)defaultName {
    
    if (!defaults) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    return [defaults integerForKey:defaultName];
}

+ (CGFloat)floatForKey:(NSString *)defaultName {

    if (!defaults) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    return [defaults floatForKey:defaultName];
}

+ (BOOL)boolForKey:(NSString *)defaultName {
    if (!defaults) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    return [defaults boolForKey:defaultName];
}

+ (void)saveDefaults {
    if (!defaults) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    
    [defaults synchronize];
}

@end
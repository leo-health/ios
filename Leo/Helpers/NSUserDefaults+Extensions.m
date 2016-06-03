//
//  NSUserDefaults+Extensions.m
//  
//
//  Created by Zachary Drossman on 11/12/15.
//
//

#import "NSUserDefaults+Extensions.h"

@implementation NSUserDefaults (Extensions)

static NSUserDefaults *defaults;

+ (void)leo_loadDefaultsWithName:(NSString *)name {

    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    [self leo_loadDefaultsWithDictionary:dictionary];
}

+ (void)leo_loadDefaultsWithDictionary:(NSDictionary *)dictionary {
    
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
        [NSUserDefaults leo_removeAllDefaults];
    }
    
    [defaults setObject:appVersion forKey:versionKey];
    [defaults synchronize];
}

+ (void)leo_removeAllDefaults {
    
    NSString *domainName = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domainName];
}

+ (NSString *)leo_stringForKey:(NSString *)defaultName {
    
    if (!defaults) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    return [defaults objectForKey:defaultName];
}

+ (void)leo_removeObjectForKey:(NSString *)defaultName {

    if (!defaults) {
        defaults = [NSUserDefaults standardUserDefaults];
    }

    [defaults setObject:nil forKey:defaultName];
}

+ (void)leo_setString:(NSString *)value forKey:(NSString *)defaultName {
    
    if (!defaults) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    [defaults setObject:value forKey:defaultName];
}

+ (NSInteger)leo_integerForKey:(NSString *)defaultName {
    
    if (!defaults) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    return [defaults integerForKey:defaultName];
}

+ (CGFloat)leo_floatForKey:(NSString *)defaultName {

    if (!defaults) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    return [defaults floatForKey:defaultName];
}

+ (BOOL)leo_boolForKey:(NSString *)defaultName {
    if (!defaults) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    return [defaults boolForKey:defaultName];
}

+ (void)leo_saveDefaults {
    if (!defaults) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    
    [defaults synchronize];
}

@end

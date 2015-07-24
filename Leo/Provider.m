//
//  Provider.m
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Provider.h"

@implementation Provider

- (instancetype)initWithObjectID:(nullable NSString *)objectID title:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(NSString *)email avatarURL:(nullable NSString *)avatarURL avatar:(UIImage *)avatar credentialSuffixes:(NSArray *)credentials specialties:(NSArray *)specialties {
    
    self = [super initWithObjectID:objectID title:title firstName:firstName middleInitial:middleInitial lastName:lastName suffix:suffix email:email avatarURL:avatarURL avatar:avatar];
    
    if (self) {
        _credentials = credentials;
        _specialties = specialties;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    self = [super initWithJSONDictionary:jsonResponse];
    
    if (self) {
        _credentials = jsonResponse[APIParamUserCredentials];
        _specialties = jsonResponse[APIParamUserSpecialties];
    }
    
    return self;
}

+ (NSDictionary *)dictionaryFromUser:(Provider *)provider {
    
    NSMutableDictionary *userDictionary = [[super dictionaryFromUser:provider] mutableCopy];
    
    userDictionary[APIParamUserCredentials] = provider.credentials;
    userDictionary[APIParamUserSpecialties] = provider.specialties;
    
    return userDictionary;
}

- (id)copy {
    

    Provider *providerCopy = [[Provider alloc] init];
    providerCopy.objectID = self.objectID;
    providerCopy.firstName = self.firstName;
    providerCopy.lastName = self.lastName;
    providerCopy.middleInitial = self.middleInitial;
    providerCopy.suffix = self.suffix;
    providerCopy.title = self.title;
    providerCopy.email = self.email;
    providerCopy.avatarURL = self.avatarURL;
    providerCopy.avatar = [self.avatar copy];
    providerCopy.specialties = self.specialties;
    providerCopy.credentials = self.credentials;
    
    return providerCopy;
}

- (NSString *)description {
    
    NSString *superDesc = [super description];
    
    NSString *subDesc = [NSString stringWithFormat:@"\nName: %@ %@",self.firstName, self.lastName];
    
    return [superDesc stringByAppendingString:subDesc];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super initWithCoder:decoder];
    
    NSArray *credentials = [decoder decodeObjectForKey:APIParamUserCredentials];
    NSArray *specialties = [decoder decodeObjectForKey:APIParamUserSpecialties];

    return [self initWithObjectID:self.objectID title:self.title firstName:self.firstName middleInitial:self.middleInitial lastName:self.lastName suffix:self.suffix email:self.email avatarURL:self.avatarURL avatar:self.avatar credentialSuffixes:credentials specialties:specialties];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:self.credentials forKey:APIParamUserCredentials];
    [encoder encodeObject:self.specialties forKey:APIParamUserSpecialties];
}

@end

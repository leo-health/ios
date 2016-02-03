//
//  Provider.m
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Provider.h"
#import "LEOS3Image.h"
#import "NSDictionary+Additions.h"

@implementation Provider

- (instancetype)initWithObjectID:(nullable NSString *)objectID title:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(NSString *)email avatar:(LEOS3Image *)avatar credentialSuffixes:(NSArray *)credentials specialties:(NSArray *)specialties {
    
    self = [super initWithObjectID:objectID title:title firstName:firstName middleInitial:middleInitial lastName:lastName suffix:suffix email:email avatar:avatar];
    
    if (self) {
        _credentials = credentials;
        _specialties = specialties;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    self = [super initWithJSONDictionary:jsonResponse];
    
    if (self) {
        _credentials = [jsonResponse leo_itemForKey:APIParamUserCredentials];
        _specialties = [jsonResponse leo_itemForKey:APIParamUserSpecialties];
    }
    
    return self;
}

+ (NSDictionary *)dictionaryFromUser:(Provider *)provider {
    
    NSMutableDictionary *userDictionary = [[super dictionaryFromUser:provider] mutableCopy];
    
    userDictionary[APIParamUserCredentials] = provider.credentials;
    userDictionary[APIParamUserSpecialties] = provider.specialties;
    
    return userDictionary;
}


- (NSString *)description {
    
    NSString *superDesc = [super description];
    
    NSString *subDesc = [NSString stringWithFormat:@"\nName: %@ %@",self.firstName, self.lastName];
    
    return [superDesc stringByAppendingString:subDesc];
}

@end

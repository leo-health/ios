//
//  LEOHelperService.m
//  Leo
//
//  Created by Zachary Drossman on 8/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOHelperService.h"

#import "LEOAPISessionManager.h"
#import "AppointmentType.h"
#import "Family.h"
#import "Practice.h"

@implementation LEOHelperService

- (NSURLSessionTask *)getAppointmentTypesWithCompletion:(void (^)(NSArray *appointmentTypes, NSError *error))completionBlock {
    
    NSURLSessionTask *task = [[LEOHelperService leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointAppointmentTypes params:nil completion:^(NSDictionary *rawResults, NSError *error) {
        
        NSArray *dataArray = rawResults[APIParamData];
        
        NSMutableArray *appointmentTypes = [[NSMutableArray alloc] init];
        
        for (NSDictionary *appointmentTypeDictionary in dataArray) {
            AppointmentType *appointmentType = [[AppointmentType alloc] initWithJSONDictionary:appointmentTypeDictionary];
            [appointmentTypes addObject:appointmentType];
        }
        
        completionBlock(appointmentTypes, error);
    }];
    
    return task;
}


- (NSURLSessionTask *)getFamilyWithCompletion:(void (^)(Family *family, NSError *error))completionBlock {
    
    NSURLSessionTask *task = [[LEOHelperService leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointFamily params:nil completion:^(NSDictionary *rawResults, NSError *error) {
        
        NSDictionary *dataDictionary = rawResults[APIParamData];
        
        Family *family = [[Family alloc] initWithJSONDictionary:dataDictionary]; //FIXME: LeoConstants
        
        //        NSString *filePath = [[self documentsDirectoryPath] stringByAppendingPathComponent:@"family"];
        //        [NSKeyedArchiver archiveRootObject:family toFile:filePath];
        
        completionBlock(family, error);
    }];
    
    return task;
}



- (NSURLSessionTask *)getPracticeWithID:(NSString *)practiceID withCompletion:(void (^)(Practice *practice, NSError *error))completionBlock {
    
    NSDictionary *practiceParams = @{APIParamID:practiceID};
    
    NSURLSessionTask *task = [[LEOHelperService leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointPractices params:practiceParams completion:^(NSDictionary *rawResults, NSError *error) {
        
        NSDictionary *dataArray = rawResults[APIParamData][@"practices"][0];
        Practice *practice = [[Practice alloc] initWithJSONDictionary:dataArray];
        
        //FIXME: Safety here
        completionBlock(practice, error);
    }];
    
    return task;
}

- (NSURLSessionTask *)getPracticesWithCompletion:(void (^)(NSArray *practices, NSError *error))completionBlock {
    
    NSURLSessionTask *task = [[LEOHelperService leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointPractices params:nil completion:^(NSDictionary *rawResults, NSError *error) {
        
        NSDictionary *dataArray = rawResults[APIParamData][@"practices"];
        
        NSMutableArray *practices = [[NSMutableArray alloc] init];
        
        for (NSDictionary *practiceDictionary in dataArray) {
            Practice *practice = [[Practice alloc] initWithJSONDictionary:practiceDictionary];
            [practices addObject:practice];
        }
        //FIXME: Safety here
        completionBlock(practices, error);
    }];
    
    return task;
}

+ (LEOAPISessionManager *)leoSessionManager {
    return [LEOAPISessionManager sharedClient];
}

@end

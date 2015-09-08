//
//  LEOAPIInsuranceOperation.m
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOAPIInsuranceOperation.h"
#import <OHHTTPStubs.h>
#import "InsurancePlan.h"
#import "Insurer.h"

@implementation LEOAPIInsuranceOperation


-(void)main {
    
//    __weak id<OHHTTPStubsDescriptor> insurerStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
//        NSLog(@"Stub request");
//        BOOL test = [request.URL.path isEqualToString:[NSString stringWithFormat:@"/%@/%@",[Configuration APIVersion], @"insurers"]];
//        return test;
//    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
//        
//        NSString *fixture = fixture = OHPathForFile(@"../Stubs/getInsurers.json", self.class);
//        OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture
//                                                                         statusCode:200
//                                                                            headers:@{@"Content-Type":@"application/json"}];
//        return response;
//        
//    }];
//
    
    Insurer *insurer = [[Insurer alloc] initWithObjectID:@"1" name:@"Aetna"];
    
    InsurancePlan *plan = [[InsurancePlan alloc] initWithObjectID:@"1" insurer:insurer name:@"PPO" supported:YES];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.requestBlock(@[plan], nil);
    }];
}

@end

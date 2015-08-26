//
//  LEOApiClientSpec.m
//  Leo
//
//  Created by Zachary Drossman on 8/19/15.
//  Copyright 2015 Leo Health. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "OHHTTPStubs.h"
//#import "KIF.h"
#import "LEOApiClient.h"
#import "Configuration.h"

SpecBegin(LEOApiClient)

describe(@"LEOApiClient", ^{
    
    beforeAll(^{

        __weak id<OHHTTPStubsDescriptor> staffStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            NSLog(@"Stub request");
            BOOL test = [request.URL.host isEqualToString:[Configuration APIEndpoint]] && [request.URL.path isEqualToString:[NSString stringWithFormat:@"/%@/%@/%@",[Configuration APIVersion], @"0", @"staff"]];
            return test;
        } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
            
            NSString *fixture = fixture = OHPathForFile(@"../Stubs/getAllStaff.json", self.class);
            OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture
                                                                             statusCode:200
                                                                                headers:@{@"Content-Type":@"application/json"}];
            return response;
            
        }];
        
        __weak id<OHHTTPStubsDescriptor> familyStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            NSLog(@"Stub request");
            BOOL test = [request.URL.host isEqualToString:[Configuration APIEndpoint]] && [request.URL.path isEqualToString:[NSString stringWithFormat:@"/%@/%@",[Configuration APIVersion], @"family"]];
            return test;
        } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
            
            NSString *fixture = fixture = OHPathForFile(@"../Stubs/getFamilyForUser.json", self.class);
            OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture
                                                                             statusCode:200
                                                                                headers:@{@"Content-Type":@"application/json"}];
            return response;
        }];

        
    });
    
    beforeEach(^{

    });
    
    it(@"", ^{

    });  
    
    afterEach(^{

    });
    
    afterAll(^{

    });
});

SpecEnd

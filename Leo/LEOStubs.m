//
//  LEOStubs.m
//  Leo
//
//  Created by Zachary Drossman on 8/26/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOStubs.h"
#import "OHHTTPStubs.h"
#import "Configuration.h"

@implementation LEOStubs

+ (void)setupConversationStubWithID:(NSString *)conversationID {
    
    __weak id<OHHTTPStubsDescriptor> messagesStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSLog(@"%@/%@/%@",APIEndpointConversations, conversationID, APIEndpointMessages);
        BOOL test = [request.URL.host isEqualToString:[Configuration APIEndpoint]] && [request.URL.path isEqualToString:[NSString stringWithFormat:@"/%@/%@/%@/%@",[Configuration APIVersion], APIEndpointConversations, conversationID, APIEndpointMessages]] && [request.HTTPMethod isEqualToString:@"GET"];
        return test;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        
        NSString *fixture = fixture = OHPathForFile(@"../Stubs/getMessagesForUser.json", self.class);
        OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        return response;
    }];
}

+ (void)setupStubs {
    
    __weak id<OHHTTPStubsDescriptor> cardStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSLog(@"Stub request");
        BOOL test = [request.URL.path isEqualToString:[NSString stringWithFormat:@"/%@/%@",[Configuration APIVersion], @"cards"]];
        return test;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        
        NSString *fixture = fixture = OHPathForFile(@"../Stubs/getCardsForUser.json", self.class);
        OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture
                                                                         statusCode:200
                                                                            headers:@{@"Content-Type":@"application/json"}];
        return response;
        
    }];
    
    __weak id<OHHTTPStubsDescriptor> staffStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSLog(@"Stub request");
        BOOL test = [request.URL.path isEqualToString:[NSString stringWithFormat:@"/%@/%@/%@",[Configuration APIVersion], @"0", @"staff"]];
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
        BOOL test = [request.URL.path isEqualToString:[NSString stringWithFormat:@"/%@/%@",[Configuration APIVersion], @"family"]];
        return test;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        
        NSString *fixture = fixture = OHPathForFile(@"../Stubs/getFamilyForUser.json", self.class);
        OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture
                                                                         statusCode:200
                                                                            headers:@{@"Content-Type":@"application/json"}];
        return response;
    }];
    
    __weak id<OHHTTPStubsDescriptor> appointmentTypesStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSLog(@"Stub request");
        BOOL test = [request.URL.path isEqualToString:[NSString stringWithFormat:@"/%@/%@",[Configuration APIVersion], @"appointment_types"]];
        return test;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        
        NSString *fixture = fixture = OHPathForFile(@"../Stubs/getAppointmentTypes.json", self.class);
        OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture
                                                                         statusCode:200
                                                                            headers:@{@"Content-Type":@"application/json"}];
        return response;
    }];
    
    //TODO: Add this stub once there is data I can pull from the server.
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
}

@end

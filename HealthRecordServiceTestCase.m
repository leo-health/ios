//
//  HealthRecordServiceTestCase.m
//  Leo
//
//  Created by Adam Fanslau on 1/7/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "User.h"
#import "LEOHealthRecordService.h"

@interface HealthRecordServiceTestCase : XCTestCase

@property (strong, nonatomic) Patient *patient;

@end

@implementation HealthRecordServiceTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // create a mock user
    self.patient = [[Patient alloc] initWithJSONDictionary:@{
        @"id": @2,
        @"title": [NSNull null],
        @"first_name": @"Danish",
        @"middle_initial": [NSNull null],
        @"last_name": @"Freeman",
        @"suffix": [NSNull null],
        @"sex": @"M",
        @"practice_id": [NSNull null],
        @"family_id": @1,
        @"email": @"user28@test.com",
        @"role": @{
            @"id": @4,
            @"name": @"guardian"
        },
        @"avatar": [NSNull null],
        @"type": @"Member",
        @"primary_guardian": @1
    }];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.

    XCTestExpectation *expectation = [self expectationWithDescription:@"Expect the api to return"];

    LEOHealthRecordService *service = [LEOHealthRecordService new];
    [service getNotesForPatient:self.patient withCompletion:^(NSArray<PatientNote *> *notes, NSError *error) {

        // ????: API fails with 403 Forbidden, I'm gussing becuase the current logged in user is not being set up correctly. How can we get tests to use real user data?

        XCTAssertNil(error);
        [expectation fulfill];
    }];


    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];


}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end

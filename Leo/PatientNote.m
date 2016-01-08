//
//  PatientNote.m
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "PatientNote.h"
#import "NSDictionary+Additions.h"
#import "LEOConstants.h"

@implementation PatientNote

-(instancetype)initWithObjectID:(NSString *)objectID user:(User *)user createdAt:(NSDate *)createdAt updatedAt:(NSDate *)updatedAt deletedAt:(NSDate *)deletedAt note:(NSString *)note {

    self = [super init];
    if (self) {

        _objectID = objectID;
        _user = user;
        _createdAt = createdAt;
        _updatedAt = updatedAt;
        _deletedAt = deletedAt;
        _note = note;
    }
    return self;
}

-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {

    NSString *objectID = [jsonDictionary leo_itemForKey:APIParamPatientNoteID];
    User *user = [[User alloc] initWithJSONDictionary:[jsonDictionary leo_itemForKey:APIParamPatientNoteUser]];
    NSDate *createdAt = [jsonDictionary leo_itemForKey:APIParamPatientNoteCreatedAt];
    NSDate *updatedAt = [jsonDictionary leo_itemForKey:APIParamPatientNoteUpdatedAt];
    NSDate *deletedAt = [jsonDictionary leo_itemForKey:APIParamPatientNoteDeletedAt];
    NSString *note = [jsonDictionary leo_itemForKey:APIParamPatientNoteNote];
    return [self initWithObjectID:objectID user:user createdAt:createdAt updatedAt:updatedAt deletedAt:deletedAt note:note];
}

+ (NSArray *)patientNotesFromDictionaries:(NSArray *)dictionaries {
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dict in dictionaries) {
        [array addObject:[[self alloc] initWithJSONDictionary:dict]];
    }
    return [array copy];
}

+(instancetype)mockObject {

    return [[self alloc] initWithJSONDictionary:@{

        @"id": @1,
        @"user": @{
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
            @"primary_guardian": @YES
        },
        @"created_at": @"2016-01-06T12:01:00.852-05:00",
        @"updated_at": @"2016-01-06T12:01:00.852-05:00",
        @"deleted_at": [NSNull null],
        @"note": @"note"
                                                  }];
}


@end

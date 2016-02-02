//
//  PatientNote.m
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "PatientNote.h"
#import "NSDictionary+Additions.h"
#import "NSDate+Extensions.h"
#import "LEOConstants.h"

@implementation PatientNote

-(instancetype)initWithObjectID:(NSString *)objectID user:(User *)user createdAt:(NSDate *)createdAt updatedAt:(NSDate *)updatedAt deletedAt:(NSDate *)deletedAt text:(NSString *)text {

    self = [super init];
    if (self) {

        _objectID = objectID;
        _user = user;
        _createdAt = createdAt;
        _updatedAt = updatedAt;
        _deletedAt = deletedAt;
        _text = text;
    }
    return self;
}

-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {

    NSString *objectID = [[jsonDictionary leo_itemForKey:APIParamPatientNoteID] stringValue];
    User *user = [[User alloc] initWithJSONDictionary:[jsonDictionary leo_itemForKey:APIParamPatientNoteUser]];
    NSDate *createdAt = [NSDate leo_dateFromDateTimeString:[jsonDictionary leo_itemForKey:APIParamPatientNoteCreatedAt]];
    NSDate *updatedAt = [NSDate leo_dateFromDateTimeString:[jsonDictionary leo_itemForKey:APIParamPatientNoteUpdatedAt]];
    NSDate *deletedAt = [NSDate leo_dateFromDateTimeString:[jsonDictionary leo_itemForKey:APIParamPatientNoteDeletedAt]];
    NSString *text = [jsonDictionary leo_itemForKey:APIParamPatientNoteNote];
    return [self initWithObjectID:objectID user:user createdAt:createdAt updatedAt:updatedAt deletedAt:deletedAt text:text];
}

+ (NSArray *)patientNotesFromDictionaries:(NSArray *)dictionaries {
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dict in dictionaries) {
        [array addObject:[[self alloc] initWithJSONDictionary:dict]];
    }
    return [array copy];
}

- (void)updateWithPatientNote:(PatientNote *)existingNote {
    self.objectID = existingNote.objectID;
    self.user = existingNote.user;
    self.createdAt = existingNote.createdAt;
    self.updatedAt = existingNote.updatedAt;
    self.deletedAt = existingNote.deletedAt;
    self.text = existingNote.text;
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

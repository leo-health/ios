//
//  Family.m
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Family.h"
#import "Patient.h"
#import "Guardian.h"

@implementation Family

- (instancetype)initWithObjectID:(NSString *)objectID guardians:(NSArray *)guardians patients:(NSArray *)patients {
    self = [super init];
    
    if (self) {
        _objectID = objectID;
        _guardians = guardians;
        _patients = patients;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    NSString *objectID = @"TEMP"; // jsonResponse[APIParamID]; FIXME: Add this back in when the id has been added back to family.
    
    NSArray *patientDictionaries = jsonResponse[APIParamUserPatients]; //FIXME: Use LEOConstants.
    
    NSMutableArray *patients = [[NSMutableArray alloc] init];
    
    for (NSDictionary *patientDictionary in patientDictionaries) {
        Patient *patient = [[Patient alloc] initWithJSONDictionary:patientDictionary];
        [patients addObject:patient];
    }
    
    NSArray *guardianDictionaries = jsonResponse[APIParamUserGuardians]; //FIXME: Update name to guardian in LEOConstants file
    NSMutableArray *guardians = [[NSMutableArray alloc] init];
    
    for (NSDictionary *guardianDictionary in guardianDictionaries) {
        Guardian *guardian = [[Guardian alloc] initWithJSONDictionary:guardianDictionary];
        [guardians addObject:guardian];
    }
    
    return [self initWithObjectID:objectID guardians:[guardians copy] patients:[patients copy]];
}

- (void)addChild:(Patient *)child {
    
    NSMutableArray *patient = [self.patients mutableCopy];
    
    [patient addObject:child];
    
    self.patients = [patient copy];
}


- (void)addGuardian:(Guardian *)guardian {
    
    NSMutableArray *guardians = [self.guardians mutableCopy];
    
    [guardians addObject:guardian];
    
    self.guardians = [guardians copy];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    NSString *objectID = [decoder decodeObjectForKey:APIParamPracticeID];
    NSArray *guardians = [decoder decodeObjectForKey:APIParamUserGuardians];
    NSArray *patients = [decoder decodeObjectForKey:APIParamUserPatients];
    
    return [self initWithObjectID:objectID guardians:guardians patients:patients];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.objectID forKey:APIParamID];
    [encoder encodeObject:self.guardians forKey:APIParamUserGuardians];
    [encoder encodeObject:self.patients forKey:APIParamUserPatients];
}


@end

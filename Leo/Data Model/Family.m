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
#import <objc/runtime.h>
#import <DateTools/DateTools.h>
#import "NSDictionary+Extensions.h"

@implementation Family

@synthesize patients = _patients;

-(instancetype)init {
    
    NSArray *guardians = [[NSArray alloc] init];
    NSArray *patients = [[NSArray alloc] init];
    return [self initWithObjectID:nil guardians:guardians patients:patients];
}

- (instancetype)initWithObjectID:(nullable NSString *)objectID guardians:(NSArray *)guardians patients:(NSArray *)patients {
    self = [super init];
    
    if (self) {
        _objectID = objectID;
        _guardians = guardians;
        _patients = patients;

        [self sortPatients];
    }

    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {

    if (!jsonDictionary) {
        return nil;
    }

    NSString *objectID = [[jsonDictionary leo_itemForKey:APIParamID] stringValue];
    NSArray *patientDictionaries = [jsonDictionary leo_itemForKey:APIParamUserPatients];
    NSMutableArray *patients = [[NSMutableArray alloc] init];
    
    for (NSDictionary *patientDictionary in patientDictionaries) {
        Patient *patient = [[Patient alloc] initWithJSONDictionary:patientDictionary];
        [patients addObject:patient];
    }
    
    NSArray *guardianDictionaries = [jsonDictionary leo_itemForKey:APIParamUserGuardians];
    NSMutableArray *guardians = [[NSMutableArray alloc] init];
    
    for (NSDictionary *guardianDictionary in guardianDictionaries) {
        Guardian *guardian = [[Guardian alloc] initWithJSONDictionary:guardianDictionary];
        [guardians addObject:guardian];
    }
    
    return [self initWithObjectID:objectID guardians:[guardians copy] patients:[patients copy]];
}

+ (NSDictionary *)serializeToJSON:(Family *)family {

    if (!family) {
        return nil;
    }

    NSMutableDictionary *jsonDictionary = [NSMutableDictionary new];
    jsonDictionary[APIParamID] = family.objectID;
    jsonDictionary[APIParamUserPatients] = [Patient serializeManyToJSON:family.patients];
    jsonDictionary[APIParamUserGuardians] = [Guardian serializeManyToJSON: family.guardians];

    return [jsonDictionary copy];
}

- (void)addPatient:(nonnull Patient *)patient {
    
    if (patient) {
        
        NSMutableArray *mutablePatients = [self.patients mutableCopy];
        
        [mutablePatients addObject:patient];
        
        self.patients = mutablePatients;
    }
}

-(NSArray *)patients {

    if (!_patients) {
        _patients = [NSArray new];
    }

    return _patients;
}

- (void)setPatients:(NSArray *)patients {

    _patients = [patients copy];
    [self sortPatients];
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
    
    return [self initWithObjectID:objectID
                        guardians:guardians
                         patients:patients];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.objectID
                   forKey:APIParamID];
    
    [encoder encodeObject:self.guardians
                   forKey:APIParamUserGuardians];
    
    [encoder encodeObject:self.patients
                   forKey:APIParamUserPatients];
}

- (void)sortPatients {

    // default sort order is oldest to youngest, then alphabetical by firstName if born on the same date
    _patients = [_patients sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dob" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]]];
}

- (BOOL)hasAdditionalCaregivers {
   return self.guardians.count > 1;
}

- (NSArray *)guardiansExceptGuardianWithID:(NSString *)objectID {

    NSMutableArray *guardians = [NSMutableArray new];
    for (Guardian *guardian in self.guardians) {
        if (![guardian.objectID isEqualToString:objectID]) {
            [guardians addObject:guardian];
        }
    }
    return [guardians copy];
}

- (Guardian *)guardianWithID:(NSString *)objectID {

    for (Guardian * guardian in self.guardians) {
        if ([guardian.objectID isEqualToString:objectID]) {
            return guardian;
        }
    }
    return nil;
}


@end

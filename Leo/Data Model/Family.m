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

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {

    NSString *objectID = jsonResponse[APIParamFamily][APIParamID];

    NSArray *patientDictionaries = jsonResponse[APIParamFamily][APIParamUserPatients];
    
    NSMutableArray *patients = [[NSMutableArray alloc] init];
    
    for (NSDictionary *patientDictionary in patientDictionaries) {
        Patient *patient = [[Patient alloc] initWithJSONDictionary:patientDictionary];
        [patients addObject:patient];
    }
    
    NSArray *guardianDictionaries = jsonResponse[APIParamFamily][APIParamUserGuardians];
    NSMutableArray *guardians = [[NSMutableArray alloc] init];
    
    for (NSDictionary *guardianDictionary in guardianDictionaries) {
        Guardian *guardian = [[Guardian alloc] initWithJSONDictionary:guardianDictionary];
        [guardians addObject:guardian];
    }
    
    return [self initWithObjectID:objectID guardians:[guardians copy] patients:[patients copy]];
}

+ (NSDictionary *)dictionaryWithPrimaryUserAndInsuranceOnlyFromFamily:(Family *)family {
    
    NSMutableDictionary *familyDictionary = [[NSMutableDictionary alloc] init];
    NSMutableArray *patientsArray = [[NSMutableArray alloc] init];
    
    for (Guardian *guardian in family.guardians) {
        
        if (guardian.primary) {
            NSDictionary *guardianDictionary = [Guardian dictionaryFromUser:guardian];
            familyDictionary[APIParamUserGuardian] = guardianDictionary;
            
            NSDictionary *insurancePlanDictionary = [InsurancePlan dictionaryFromInsurancePlan:guardian.insurancePlan];
            
            familyDictionary[APIParamInsurancePlan] = insurancePlanDictionary  ;
        }
    }
    
    for (Patient *patient in family.patients) {
        
        NSDictionary *patientDictionary = [Patient dictionaryFromUser:patient];
        [patientsArray addObject:patientDictionary];
    }
    
    familyDictionary[APIParamUserPatients] = patientsArray;
    
    return [familyDictionary copy];
}

- (void)addPatient:(nonnull Patient *)patient {
    
    if (patient) {
        
        NSMutableArray *mutablePatients = [self.patients mutableCopy];
        
        [mutablePatients addObject:patient];
        
        self.patients = [mutablePatients copy];

        [self sortPatients];
    }
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
    self.patients = [self.patients sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dob" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]]];
}

@end

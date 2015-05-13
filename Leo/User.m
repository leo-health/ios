//
//  User.m
//  Leo
//
//  Created by Zachary Drossman on 5/13/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithFirstName:(nonnull NSString *)firstName lastName:(nonnull NSString *)lastName dob:(nonnull NSDate *)dob email:(nonnull NSString*)email familyId:(NSNumber *)familyID
{
    self = [super init];
    if (self) {
        _firstName = firstName;
        _lastName = lastName;
        _dateOfBirth = dob;
        _email = email;
        _familyID = familyID;
    }
    return self;
}

@end

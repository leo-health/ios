//
//  User.h
//  Leo
//
//  Created by Zachary Drossman on 5/13/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum Gender {
    male,
    female,
    undisclosed
} Gender;

@interface User : NSObject

@property (copy, nonatomic, nullable) NSString *title;
@property (copy, nonatomic, nonnull) NSString *firstName;
@property (copy, nonatomic, nullable) NSString *middleInitial;
@property (copy, nonatomic, nonnull) NSString *lastName;
@property (strong, nonatomic, nonnull) NSDate *dateOfBirth;
@property (nonatomic) Gender gender;
@property (strong, nonatomic, nonnull) NSString *email;
@property (strong, nonatomic, nullable) NSString *encrypted_password; //null until creation on the server
@property (strong, nonatomic, nullable) NSNumber *practiceID; //null until creation on the server
@property (copy, nonatomic, nullable) NSString *token; //null until login
@property (strong, nonatomic, nullable) NSNumber *familyID; //null until creation on the server
@property (strong, nonatomic, nullable) NSNumber *userID; //null until creation on the server

@end

//create_table "users", force: :cascade do |t|
//t.string   "title",                  default: ""
//t.string   "first_name",             default: "", null: false
//t.string   "middle_initial",         default: ""
//t.string   "last_name",              default: "", null: false
//t.datetime "dob"
//t.string   "sex"
//t.integer  "practice_id"
//t.string   "email",                  default: "", null: false
//t.string   "encrypted_password",     default: ""
//t.string   "reset_password_token"
//t.datetime "reset_password_sent_at"
//t.datetime "remember_created_at"
//t.integer  "sign_in_count",          default: 0,  null: false
//t.datetime "current_sign_in_at"
//t.datetime "last_sign_in_at"
//t.string   "current_sign_in_ip"
//t.string   "last_sign_in_ip"
//t.datetime "created_at"
//t.datetime "updated_at"
//t.string   "invitation_token"
//t.datetime "invitation_created_at"
//t.datetime "invitation_sent_at"
//t.datetime "invitation_accepted_at"
//t.integer  "invitation_limit"
//t.integer  "invited_by_id"
//t.string   "invited_by_type"
//t.integer  "invitations_count",      default: 0
//t.string   "authentication_token"
//t.integer  "family_id"
//end
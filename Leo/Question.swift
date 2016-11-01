//
//  Question.swift
//  Leo
//
//  Created by Adam Fanslau on 10/31/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation

class Question : NSObject, JSONSerializable {

    let objectID: String
    let survey_id: String
    let order: Int
    let question_type: String
    let body: String
    let secondary: String

    init(
        objectID: String,
        survey_id: String,
        order: Int,
        question_type: String,
        body: String,
        secondary: String
        ) {
        self.objectID = objectID
        self.survey_id = survey_id
        self.order = order
        self.question_type = question_type
        self.body = body
        self.secondary = secondary
        super.init()
    }

    convenience required init?(json: JSON) {

        guard let objectID = json["id"].map({String(describing: $0)}) else { return nil }
        guard let survey_id = json["survey_id"].map({String(describing: $0)}) else { return nil }
        guard let order = json["order"] as? Int else { return nil }
        guard let question_type = json["question_type"] as? String else { return nil }
        guard let body = json["body"] as? String else { return nil }
        guard let secondary = json["secondary"] as? String else { return nil }

        self.init(
            objectID: objectID,
            survey_id: survey_id,
            order: order,
            question_type: question_type,
            body: body,
            secondary: secondary
        )
    }

    public func json() -> [String : Any] {
        return [
            "id": objectID,
            "survey_id": survey_id,
            "order": order,
            "question_type": question_type,
            "body": body,
            "secondary": secondary
        ]
    }

    static func initMany(json: [JSON]) -> [Question] {
        return json.flatMap{Question(json: $0)}
    }
    
    static func json(objects: [Question]) -> [JSON] {
        return objects.map{$0.json()}
    }
}

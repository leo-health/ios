//
//  Survey.swift
//  Leo
//
//  Created by Adam Fanslau on 10/31/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation

class Survey : NSObject, JSONSerializable {
    let objectID: String
    let name: String
    let survey_description: String
    let survey_type: String
    let prompt: String
    let instructions: String
    let media: LEOS3Image?
    let required: Bool
    let reason: String
    let questions: [Question]
    var currentQuestionIndex: Int
    init(
        objectID: String,
        name: String,
        survey_description: String,
        survey_type: String,
        prompt: String,
        instructions: String,
        media: LEOS3Image?,
        required: Bool,
        reason: String,
        questions: [Question],
        currentQuestionIndex: Int
        ) {
        self.objectID = objectID
        self.name = name
        self.survey_description = survey_description
        self.survey_type = survey_type
        self.prompt = prompt
        self.instructions = instructions
        self.media = media
        self.required = required
        self.reason = reason
        self.questions = questions
        self.currentQuestionIndex = currentQuestionIndex
        super.init()

    }

    required convenience init?(json: JSON) {

        guard let objectID = json["id"].map({String(describing: $0)}) else { return nil }
        guard let name = json["name"] as? String else { return nil }
        guard let survey_description = json["survey_description"] as? String else { return nil }
        guard let survey_type = json["survey_type"] as? String else { return nil }
        guard let prompt = json["prompt"] as? String else { return nil }
        guard let instructions = json["instructions"] as? String else { return nil }
        let media = json["media"] as? LEOS3Image
        guard let required = json["required"] as? Bool else { return nil }
        guard let reason = json["reason"] as? String else { return nil }
        guard let questionsJSON = json["questions"] as? [JSON] else { return nil }
        let questions = questionsJSON.flatMap{Question(json: $0)}
        let currentQuestionIndex = json["currentQuestionIndex"] as? Int ?? 0

        self.init(
            objectID: objectID,
            name: name,
            survey_description: survey_description,
            survey_type: survey_type,
            prompt: prompt,
            instructions: instructions,
            media: media,
            required: required,
            reason: reason,
            questions: questions,
            currentQuestionIndex: 5 //currentQuestionIndex
        )
    }

    static func initMany(json: [JSON]) -> [Survey] {
        return json.flatMap{Survey(json: $0)}
    }

    static func json(objects: [Survey]) -> [JSON] {
        return objects.map{$0.json()}
    }

    public func json() -> [String : Any] {

        var json: [String : Any] = [
            "id": objectID,
            "name": name,
            "survey_description": survey_description,
            "survey_type": survey_type,
            "prompt": prompt,
            "instructions": instructions,
            "required": required,
            "reason": reason,
            "questions": Question.json(objects: questions),
            "currentQuestionIndex" : currentQuestionIndex
        ]
        
        if let media = media {
            json["media"] = media.serializeToJSON()
        }
        
        return json
    }
}

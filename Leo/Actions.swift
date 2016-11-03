//
//  Actions.swift
//  Leo
//
//  Created by Adam Fanslau on 10/26/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation

class ActionTypes : NSObject {
    static let BeginSurvey = "BEGIN_SURVEY"
    static let ScheduleNewAppointment = "SCHEDULE_NEW_APPOINTMENT"
    static let RescheduleAppointment = "RESCHEDULE"
    static let CancelAppointmentCard = "CANCEL_APPOINTMENT_CARD"
    static let ChangeCardState = "CHANGE_CARD_STATE"
    static let DismissCard = "DISMISS_CARD"
    static let DismissContentCard = "DISMISS_CONTENT_CARD"
    static let OpenUrl = "OPEN_URL"
    static let OpenPracticeConversation = "OPEN_PRACTICE_CONVERSATION"
}

class Action : NSObject, JSONSerializable {
    let actionType: String
    let payload: [String : Any]
    let displayName: String?

    init(
      actionType: String,
      payload: [String : Any],
      displayName: String?
    ) {
      self.actionType = actionType
      self.payload = payload
      self.displayName = displayName

      super.init()
    }

    convenience init(
        actionType: String,
        payload: [String : Any]
    ) {
        self.init(
            actionType: actionType,
            payload: payload,
            displayName: nil
        )
    }

    static func json(_ objects: [Action]) -> [JSON] {
        return objects.map({object in object.json()})
    }

    static func initMany(jsonArray: [JSON]) -> [Action] {
        return jsonArray.flatMap({ Action(json: $0) })
    }

    required convenience init?(json: JSON) {
        guard let actionType = json["action_type"] as? String else { return nil }
        guard let payload = json["payload"] as? JSON else { return nil }
        let displayName = json["display_name"] as? String

        self.init(
            actionType: actionType,
            payload: payload,
            displayName: displayName
        )
    }

    func json() -> JSON {
        return [
          "action_type": actionType,
          "payload": payload,
          "display_name": displayName
        ]
    }
}

class ActionCreators : NSObject {

    class func changeCardState(cardID: Int, nextStateID: String, isLoading: Bool) -> Action {
        return Action(
            actionType: ActionTypes.ChangeCardState,
            payload: [
                "card_id": cardID,
                "next_state_id": nextStateID,
                "is_loading": isLoading
            ]
        )
    }

    class func changeCardState(cardID: Int, nextStateID: String) -> Action {
        return Action(
            actionType: ActionTypes.ChangeCardState,
            payload: [
                "card_id": cardID,
                "next_state_id": nextStateID
            ]
        )
    }

    class func changeCardState(cardID: Int, isLoading: Bool) -> Action {
        return Action(
            actionType: ActionTypes.ChangeCardState,
            payload: [
                "card_id": cardID,
                "is_loading": isLoading
            ]
        )
    }

    class func scheduleNewAppointment() -> Action {
        return Action(
            actionType: ActionTypes.ScheduleNewAppointment,
            payload: [:]
        )
    }

    class func openPracticeConversation() -> Action {
        return Action(
            actionType: ActionTypes.OpenPracticeConversation,
            payload: [:]
        )
    }
}

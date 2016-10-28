//
//  Actions.swift
//  Leo
//
//  Created by Adam Fanslau on 10/26/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation

public class ActionTypes : NSObject {
    static let ScheduleNewAppointment = "SCHEDULE_NEW_APPOINTMENT"
    static let ChangeCardState = "CHANGE_CARD_STATE"
}

public class Action : NSObject {
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
}

public class ActionCreators {
    class func action(json: [String : Any]) -> Action {
        return Action(
            actionType: json["action_type"] as! String,
            payload: json["payload"] as! [String : Any],
            displayName: json["display_name"] as! String?
        )
    }

    class func scheduleNewAppointment() -> Action {
        return Action(
            actionType: ActionTypes.ScheduleNewAppointment,
            payload: [:],
            displayName: nil
        )
    }
}

public class ActionHandler: NSObject {

    class func handle(action: Action) {

        switch action.actionType {
        case ActionTypes.ScheduleNewAppointment:
            // TODO: ????: how to take advantage of type safety here?
            AppRouter.router.pushScheduling()
        case ActionTypes.ChangeCardState:

            // TODO: ????: These casts should probably be guards. We want to fail gracefully here, and currently the app will crash
            guard let cardID = action.payload["card_id"] as? Int else { return }
            guard let nextStateID = action.payload["next_state_id"] as? String else { return }

            CardService.cacheOnly().updateCard(
                cardID: cardID,
                stateID: nextStateID
            )
        default:
            break
        }
    }

    class func handle(url: URL) {
        if url.pathComponents.count < 2 { return }
        let endpoint = url.pathComponents[1]

        switch endpoint {
        case "schedule":
            handle(action: ActionCreators.scheduleNewAppointment())
        default:
            break
        }
    }
}

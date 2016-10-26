//
//  AppRouter.swift
//  Leo
//
//  Created by Zachary Drossman on 10/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import UIKit

public class ActionTypes {
    static let ScheduleNewAppointment = "SCHEDULE_NEW_APPOINTMENT"
    static let TryCancelAppointment = "TRY_CANCEL_APPOINTMENT"
}


public struct Action {
    let actionType: String
    let payload: [String : Any]
    let displayName: String?
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

    class func handle(action: Action) {

        switch action.actionType {
        case ActionTypes.ScheduleNewAppointment:
            // TODO: ????: how to take advantage of type safety here?
            AppRouter.router.pushScheduling()
        case ActionTypes.TryCancelAppointment:

        default:
            break
        }
    }
}

public struct CardState {
    
}

public class AppRouter: NSObject {

    public static let router = AppRouter()

    var feedTVC: LEOFeedTVC?

    public func setRootVC(feedTVC: LEOFeedTVC) {

        feedTVC.scheduleNewAppointment = {
            ActionHandler.handle(action: Action(
                actionType: ActionTypes.ScheduleNewAppointment,
                payload: [:],
                displayName: nil
            ))
        }

        self.feedTVC = feedTVC
    }

    public func pushScheduling() {

        // TODO: configure appointment VC here

        feedTVC?.beginSchedulingNewAppointment()
    }
}

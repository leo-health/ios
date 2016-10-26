//
//  AppRouter.swift
//  Leo
//
//  Created by Zachary Drossman on 10/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import UIKit

public struct Action {
    let actionType: Action.ActionType
    let payload: [String : Any]
    let displayName: String?

    enum ActionType: String {
        case ScheduleNewAppointment = "SCHEDULE_NEW_APPOINTMENT"
    }
}

public class ActionHandler: NSObject {
    class func handle(action: Action) {
        switch action.actionType {
        case .ScheduleNewAppointment:
            // TODO: ????: how to take advantage of type safety here?
            AppRouter.router.pushScheduling()
        }
    }
}




public class AppRouter: NSObject {

    public static let router = AppRouter()

//    var navigationController: UINavigationController?

    var feedTVC: LEOFeedTVC?

//    override init() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        navigationController = appDelegate.window.rootViewController as! UINavigationController
//        super.init()
//    }

    public func setFeedRootVC(feedTVC: LEOFeedTVC) {

        feedTVC.scheduleNewAppointment = {
            ActionHandler.handle(action: Action(
                actionType: Action.ActionType.ScheduleNewAppointment,
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

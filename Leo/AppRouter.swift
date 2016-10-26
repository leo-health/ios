//
//  AppRouter.swift
//  Leo
//
//  Created by Zachary Drossman on 10/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import UIKit

public class AppRouter: NSObject {

    public static let router = AppRouter()
    private override init() {
        super.init()
    }

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

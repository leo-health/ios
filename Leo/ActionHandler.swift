//
//  ActionHandler.swift
//  Leo
//
//  Created by Adam Fanslau on 10/28/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation

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


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

        case ActionTypes.BeginSurvey:
            AppRouter.router.presentExpandedCardSurvey(
                survey: Survey(
                    questions: [
                        Question(question: "one"),
                        Question(question: "two"),
                        Question(question: "three")
                    ]
                )
            )

        case ActionTypes.ScheduleNewAppointment:

            AppRouter.router.presentExpandedCardScheduling(appointment: nil)

        case ActionTypes.RescheduleAppointment:

            guard let appointmentID =
                action.payload["appointment_id"] as? Int
                else { return }

            guard let appointment =
                AppointmentService.cacheOnly().getAppointment(appointmentID: String(appointmentID))
                else { return }

            AppRouter.router.presentExpandedCardScheduling(appointment: appointment)

        case ActionTypes.OpenPracticeConversation:

            // TODO: LATER: handle conversation by id in cache
            guard let conversation =
                ConversationService.cacheOnly().getConversation()
                else { return }

            AppRouter.router.presentExpandedCardConversation(conversation: conversation)

        case ActionTypes.ChangeCardState:

            // TODO: ????: How do we validate payload types with these actions?

            guard let cardID = action.payload["card_id"] as? Int
                else { return }
            guard let nextStateID = action.payload["next_state_id"] as? String
                else { return }

            CardService.cacheOnly().updateCard(
                cardID: cardID,
                stateID: nextStateID
            )

        case ActionTypes.DismissCard:
            guard let cardID = action.payload["card_id"] as? Int else { return }

            CardService.cacheOnly().deleteCard(
                cardID: cardID
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

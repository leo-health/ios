//
//  ActionHandler.swift
//  Leo
//
//  Created by Adam Fanslau on 10/28/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation

public class ActionHandler: NSObject {

    // ????: What should the return type of handle be?
    class func handle(action: Action) {

        switch action.actionType {

        case ActionTypes.CancelAppointmentCard:
            handleAsync(action: action)

        case ActionTypes.BeginSurvey:

            guard let id = (action.payload["user_survey_id"] as? Int).map({String($0)}) else { return }
            guard let survey = SurveyService().getSurvey(id: id) else { return }
            AppRouter.router.presentExpandedCardSurvey(survey: survey)

        case ActionTypes.ScheduleNewAppointment:

            AppRouter.router.presentExpandedCardScheduling(appointment: nil)

        case ActionTypes.RescheduleAppointment:

            guard let appointmentID =
                action.payload["appointment_id"] as? Int
                else { return }

            guard let appointment =
                AppointmentService().getAppointment(appointmentID: String(appointmentID))
                else { return }

            AppRouter.router.presentExpandedCardScheduling(appointment: appointment)

        case ActionTypes.OpenPracticeConversation:

            // TODO: LATER: handle conversation by id in cache
            guard let conversation =
                ConversationService().getConversation()
                else { return }

            AppRouter.router.presentExpandedCardConversation(conversation: conversation)

        case ActionTypes.ChangeCardState:

            guard let cardID = action.payload["card_id"] as? Int
                else { return }

            let nextStateID = action.payload["next_state_id"] as? String
            let isLoading = action.payload["is_loading"] as? Bool

            if (nextStateID == nil && isLoading == nil) { return }

            CardService().updateCard(
                cardID: cardID,
                stateID: nextStateID,
                isLoading: isLoading
            )

        case ActionTypes.DismissCard:

            guard let cardID = action.payload["card_id"] as? Int else { return }
            CardService().deleteCard(cardID: cardID)

        case ActionTypes.DismissContentCard:

            guard let contentID = action.payload["user_link_preview_id"] as? Int else { return }
            guard let cardID = action.payload["card_id"] as? Int else { return }
            CardService().deleteCard(cardID: cardID)

            let _ = CardService().deleteContentCard(
                contentID: contentID,
                completion: nil
            )

        case ActionTypes.OpenUrl:
            guard let url = (action.payload["url"] as? String).flatMap({URL(string: $0)}) else { return }
            guard UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.openURL(url)

        case ActionTypes.CallPhone:
            guard let phoneNumber = action.payload["phone_number"] as? String else { return }
            guard let contactName = action.payload["contact_name"] as? String else { return }
            AppRouter.router.presentCallUsConfirmationAlert(name: contactName, phoneNumber: phoneNumber)

        default:
            break
        }
    }

    // TODO: type safety for AsyncAction
    class func handleAsync(action: Action) {

        switch action.actionType {

        case ActionTypes.CancelAppointmentCard:

            guard let appointmentID =
                (action.payload["appointment_id"] as? Int).map({String($0)})
                else { return }
            guard let nextStateID =
                action.payload["next_state_id"] as? String
                else { return }
            guard let cardID =
                action.payload["card_id"] as? Int
                else { return }

            ActionHandler.handle(action: ActionCreators.changeCardState(cardID: cardID, isLoading: true))

            let _ = AppointmentService().cancel(appointmentID: appointmentID) { _ in
                ActionHandler.handle(action: ActionCreators.changeCardState(cardID: cardID, nextStateID: nextStateID, isLoading: false))
            }

        default:
            break
        }
    }

    // 
    // NOTE: All Deep Links should pass through this function
    //
    class func handle(url: URL) {
        if url.pathComponents.count < 2 { return }
        let endpoint = url.pathComponents[1]

        // NOTE: if we assume enpoint:param: signature, and consistent naming, we can simplpy pass the action through
//        let action = Action(actionType: endpoint, payload: [:])

        switch endpoint {
        case "schedule":
            handle(action: ActionCreators.scheduleNewAppointment())
        case "complete_survey":
            handle(action: ActionCreators.beginSurvey())
        default:
            break
        }
    }
}

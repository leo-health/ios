//
//  AppRouter.swift
//  Leo
//
//  Created by Zachary Drossman on 10/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import UIKit

public class AppRouter: NSObject {

    static let router = AppRouter()

    var feedTVC: LEOFeedTVC?
    var currentNav: UINavigationController?

    private var transitioningDelegate: LEOTransitioningDelegate?

    func setRootVC(feedTVC: LEOFeedTVC) {

        feedTVC.scheduleNewAppointment = {
            ActionHandler.handle(action: Action(
                actionType: ActionTypes.ScheduleNewAppointment,
                payload: [:],
                displayName: nil
            ))
        }

        self.feedTVC = feedTVC
        self.currentNav = feedTVC.navigationController
    }

//    MARK: FeedTVC
    private func presentExpandedCard(viewController: UINavigationController) {

        // TODO: Add a method to ensure the feed is available to present the expanded card

        currentNav = viewController

        transitioningDelegate = LEOTransitioningDelegate(transitionAnimatorType: .cardModal)
        viewController.transitioningDelegate = transitioningDelegate
        viewController.modalPresentationStyle = .fullScreen
        feedTVC?.present(viewController, animated: true, completion: nil)
    }

//    MARK: Navigation Controller
    private func pushOntoCurrentNavStack(viewController: UIViewController) {
        currentNav?.pushViewController(viewController, animated: true)
    }

    private func resetNavStateThenPush(viewController: UIViewController) {

    }

//    MARK: present specific expanded cards
    func presentExpandedCardScheduling(appointment: Appointment?) {

        let emptyAppointment: ()->(Appointment?) = {
            let policy = LEOCachePolicy.cacheOnly()
            guard let practice = LEOPracticeService(cachePolicy: policy).getCurrentPractice() else { return nil }
            guard let bookedBy = LEOUserService(cachePolicy: policy).getCurrentUser() else { return nil }
            guard let family = LEOFamilyService(cachePolicy: policy).getFamily() else { return nil }
            let patient = family.patients.count == 1 ? family.patients.first : nil
            return Appointment(patient: patient, practice: practice, bookedBy: bookedBy)
        }

        guard let appointment = appointment ?? emptyAppointment() else { return }
        guard let viewController = configureAppointmentViewController(appointment: appointment) else { return }

        presentExpandedCard(viewController: viewController)
    }

    func presentExpandedCardConversation(conversation: Conversation) {

        guard let viewController = configureConversationViewController(conversation: conversation) else { return }

        presentExpandedCard(viewController: viewController)
    }

    func presentExpandedCardSurvey(survey: Survey) {

        guard let viewController = configureSurveyNavigationController(survey: survey) else { return }
        
        presentExpandedCard(viewController: viewController)
    }

//    MARK: configure expanded card VCs
    private func configureSurveyViewController(survey: Survey, index: Int) -> SurveyViewController? {

        let surveyStoryboard = UIStoryboard(name: "Survey", bundle: nil)
        guard let surveyVC = surveyStoryboard.instantiateInitialViewController() as? SurveyViewController
            else { return nil }

        guard index < survey.questions.count else { return nil }

        surveyVC.showsBackButton = index > 0
        surveyVC.question = survey.questions[index]

        surveyVC.routeNext = {

            guard let nextQuestionVC =
                self.configureSurveyViewController(
                    survey: survey,
                    index: index + 1
                ) else { return }

            self.pushOntoCurrentNavStack(viewController: nextQuestionVC)
        }

        surveyVC.routeDismissExpandedCard = {
            self.feedTVC?.dismiss(
                animated: true,
                completion: nil
            )
        }
        return surveyVC
    }

    private func configureSurveyNavigationController(survey: Survey) -> UINavigationController? {

        guard let surveyVC = configureSurveyViewController(survey: survey, index: 0) else { return nil }

        let surveyNavController = UINavigationController(rootViewController: surveyVC)
        return surveyNavController
    }

    private func configureConversationViewController(conversation: Conversation) -> UINavigationController? {

        let conversationStoryboard = UIStoryboard(name: "Conversation", bundle: nil)
        guard let conversationNavController = conversationStoryboard.instantiateInitialViewController() as? UINavigationController else { return nil }
        guard let conversationVC = conversationNavController.viewControllers.first as? LEOConversationViewController else { return nil }

        conversationVC.conversation = conversation
        conversationVC.tintColor = .leo_blue()

        return conversationNavController
    }

    private func configureAppointmentViewController(appointment: Appointment) -> UINavigationController? {

        let appointmentStoryboard = UIStoryboard(name: "Appointment", bundle: nil)
        guard let appointmentNavController = appointmentStoryboard.instantiateInitialViewController() as? UINavigationController else { return nil }
        guard let appointmentVC = appointmentNavController.viewControllers.first as? LEOAppointmentViewController else { return nil }

        appointmentVC.associatedAppointment = appointment
        appointmentVC.tintColor = .leo_green()

        return appointmentNavController
    }

}

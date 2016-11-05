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

    var window: UIWindow?

    private var presentingVC: UIViewController? {
        if var topController = self.window?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }

    private var navigationVC: UINavigationController? {
        return presentingVC as? UINavigationController
    }

    private var transitioningDelegate: LEOTransitioningDelegate?

//    MARK: Expanded Card Presentation
    private func presentExpandedCard(viewController: UINavigationController) {

        transitioningDelegate = LEOTransitioningDelegate(transitionAnimatorType: .cardModal)
        viewController.transitioningDelegate = transitioningDelegate
        viewController.modalPresentationStyle = .fullScreen
        presentingVC?.present(viewController, animated: true, completion: nil)
    }


//    MARK: Push Presentation

    private func presentExpandedCard(viewController: UINavigationController, animated: Bool) {

        // TODO: Add a method to ensure the feed is available to present the expanded card

        navigationVC = viewController

        transitioningDelegate = LEOTransitioningDelegate(transitionAnimatorType: .cardModal)
        viewController.transitioningDelegate = transitioningDelegate
        viewController.modalPresentationStyle = .fullScreen
        _presentingVC?.present(viewController, animated: animated, completion: nil)
    }


//    MARK: Navigation Controller

    private func pushOntoCurrentNavStack(viewController: UIViewController) {
        navigationVC?.pushViewController(viewController, animated: true)
    }

    func presentCallUsConfirmationAlert(name: String, phoneNumber: String) {

        let alert = UIAlertController(
            title: "You are about to call\n\(name)\n\(phoneNumber)",
            message: nil,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Call", style: .default) { _ in
            ActionHandler.handle(action: ActionCreators.openURL("tel://\(phoneNumber)"))
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        presentingVC?.present(alert, animated: true, completion: nil)
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
        surveyVC.surveyID = survey.objectID
        surveyVC.surveyName = survey.name
        surveyVC.question = survey.questions[index]
        surveyVC.questionNumber = index + 1
        surveyVC.questionCount = survey.questions.count
        surveyVC.routeNext = {

            if(surveyVC.questionNumber == surveyVC.questionCount) {

                guard let finishedSurveyVC = self.configureCompletedSurveyVC(survey: survey)
                    else {return}
                self.pushOntoCurrentNavStack(viewController:finishedSurveyVC)
            } else {

                guard let nextQuestionVC =
                    self.configureSurveyViewController(survey: survey,
                                                       index: index + 1)
                    else { return }
                self.pushOntoCurrentNavStack(viewController: nextQuestionVC)
            }
        }

        surveyVC.routeDismissExpandedCard = {
            self.presentingVC?.dismiss(
                animated: true,
                completion: nil
            )
        }

        return surveyVC
    }
    
    private func configureCompletedSurveyVC(survey: Survey) -> UIViewController? {

        let surveyStoryboard = UIStoryboard(name: String(describing: CompletedSurveyViewController.self), bundle: nil)
        guard let completedSurveyVC = surveyStoryboard.instantiateInitialViewController() as? CompletedSurveyViewController
            else { return nil }

        completedSurveyVC.surveyName = survey.name
        completedSurveyVC.routeDismissExpandedCard = {
            self._presentingVC?.dismiss(animated: true,
                                        completion: nil)
        }

        return completedSurveyVC
    }

    private func configureSurveyNavigationController(survey: Survey) -> UINavigationController? {

        let surveyVCs = Array(0...survey.currentQuestionIndex).flatMap {
            configureSurveyViewController(survey: survey, index: $0)
        }

        let surveyNavController = UINavigationController()

        surveyNavController.setViewControllers(surveyVCs, animated: false)

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

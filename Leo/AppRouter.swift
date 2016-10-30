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
    private var transitioningDelegate: LEOTransitioningDelegate?

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

    public func presentExpandedCardScheduling() {

        // TODO: configure appointment VC here

        feedTVC?.beginSchedulingNewAppointment()
    }

    public func presentExpandedCardConversation(conversation: Conversation) {

        guard let viewController = configureConversationViewController(conversation: conversation) else { return }

        presentExpandedCard(viewController: viewController)
    }

    private func presentExpandedCard(viewController: UIViewController) {

        // TODO: Add a method to ensure the feed is available to present the expanded card

        transitioningDelegate = LEOTransitioningDelegate(transitionAnimatorType: .cardModal)
        viewController.transitioningDelegate = transitioningDelegate
        viewController.modalPresentationStyle = .fullScreen
        feedTVC?.present(viewController, animated: true, completion: nil)
    }

    private func configureConversationViewController(conversation: Conversation) -> UIViewController? {

        let conversationStoryboard = UIStoryboard(name: "Conversation", bundle: nil)
        guard let conversationNavController = conversationStoryboard.instantiateInitialViewController() as? UINavigationController else { return nil }
        guard let conversationVC = conversationNavController.viewControllers.first as? LEOConversationViewController else { return nil }

        conversationVC.conversation = conversation
        conversationVC.tintColor = .leo_blue()

        return conversationNavController
    }
}

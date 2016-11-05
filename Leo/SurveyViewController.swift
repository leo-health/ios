//
//  SurveyViewController.swift
//  Leo
//
//  Created by Adam Fanslau on 10/31/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation
import MBProgressHUD

protocol ExpandedCardDelegate {
    func dismiss()
}

class SurveyViewController : UIViewController, ExpandedCardDelegate {

    var showsBackButton = false
    var questionNumber = 1
    var questionCount = 1
    var surveyID : String?
    var surveyName: String?
    var question: Question?

    var routeNext: (()->())?
    var routeDismissExpandedCard: (()->())?

    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var progressLabel: UILabel!
    @IBOutlet private weak var submitYesButton: UIButton!
    @IBOutlet private weak var submitNoButton: UIButton!
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var additionalInstructionsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        questionLabel.font = .leo_medium19()
        questionLabel.textColor = .leo_gray87()
        additionalInstructionsLabel.font = .leo_medium15()
        additionalInstructionsLabel.textColor = .leo_gray176()

        progressLabel.font = .leo_bold12()
        progressLabel.textColor = .leo_orangeRed()
        submitYesButton.titleLabel?.font = .leo_demiBold12()
        submitNoButton.titleLabel?.font = .leo_demiBold12()

        configure()
    }



    private func configure() {
        configureNavigationBar()

        questionLabel.text = question?.body
        additionalInstructionsLabel.text = question?.secondary
        progressLabel.text = "Question \(questionNumber) of \(questionCount)"
        iconView.image = question?.icon
        [submitYesButton, submitNoButton].flatMap{$0}.forEach { button in
            button.backgroundColor = .leo_orangeRed()
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .leo_medium12()
        }
    }

    private func configureNavigationBar() {
        LEOStyleHelper.styleNavigationBar(for: self,
                                          for: .PHR,
                                          withTitleText: surveyName,
                                          dismissal: true,
                                          backButton: showsBackButton)
    }

    @IBAction private func didTapSubmit(sender: UIButton) {

        guard let buttonText = sender.titleLabel?.text else { return }
        submitQuestion(text: buttonText)
    }

    func dismiss() {
        routeDismissExpandedCard?()
    }

    private func submitQuestion(text: String) {

        guard let surveyID = surveyID else { return }
        guard let objectID = question?.objectID else { return }

        MBProgressHUD.showAdded(to: view, animated: true)

        SurveyService().post(survey_id: surveyID, question_id: objectID, answer: text) { error in

            MBProgressHUD.hide(for: self.view, animated: true)
            guard error == nil else { return }
            self.routeNext?()
        }
    }
}

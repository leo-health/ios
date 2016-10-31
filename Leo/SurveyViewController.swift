//
//  SurveyViewController.swift
//  Leo
//
//  Created by Adam Fanslau on 10/31/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation

struct Survey {
    let questions: [Question]
//
//    var currentQuestionIndex: Int
//
//    var currentQuestion: Question {
//        get {
//            return questions[currentQuestionIndex]
//        }
//    }
//
//    mutating func nextQuestion() -> Question? {
//        let nextIndex = currentQuestionIndex + 1
//        guard nextIndex < questions.count else { return nil }
//        currentQuestionIndex = nextIndex
//        return currentQuestion
//    }
}

struct Question {
    let question: String
}

protocol ExpandedCardDelegate {
    func renderNavigationBar()
    func dismiss()
}

class SurveyViewController : UIViewController, ExpandedCardDelegate {

    var question: Question! {
        didSet {
            render()
        }
    }

    var routeNext: (()->())?
    var routeDismissExpandedCard: (()->())?

    @IBOutlet private weak var questionLabel: UILabel?
    @IBOutlet private weak var submitYesButton: UIButton?
    @IBOutlet private weak var submitNoButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }

    private func render() {
        renderNavigationBar()

        questionLabel?.text = question.question
    }

    func renderNavigationBar() {
        LEOStyleHelper.styleNavigationBar(for: self, for: .PHR, withTitleText: "MCHAT", dismissal: true, backButton: true)
    }

    @IBAction private func didTapSubmit(sender: UIButton) {

        submitQuestion()
    }

    func dismiss() {
        routeDismissExpandedCard?()
    }

    private func submitQuestion() {
        // post request
        // completion
        routeNext?()
    }
}

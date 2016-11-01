//
//  SurveyViewController.swift
//  Leo
//
//  Created by Adam Fanslau on 10/31/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation

protocol ExpandedCardDelegate {
    func renderNavigationBar()
    func dismiss()
}

class SurveyViewController : UIViewController, ExpandedCardDelegate {

    var showsBackButton: Bool = false
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

        questionLabel?.text = question.body

        [submitYesButton, submitNoButton].flatMap{$0}.forEach { button in
            button.backgroundColor = .leo_orangeRed()
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .leo_medium12()
        }
    }

    func renderNavigationBar() {
        LEOStyleHelper.styleNavigationBar(for: self, for: .PHR, withTitleText: "MCHAT", dismissal: true, backButton: showsBackButton)
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

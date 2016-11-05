//
//  CompletedSurveyViewController.swift
//  Leo
//
//  Created by Zachary Drossman on 11/3/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import UIKit

import Foundation
import MBProgressHUD

class CompletedSurveyViewController : UIViewController {

    var surveyID : String?
    var surveyName: String?
    var surveyFinishedIcon: UIImage?

    var routeDismissExpandedCard: (()->())?

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var subtitleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.font = .leo_medium19()
        titleLabel.textColor = .leo_gray87()
        subtitleLabel.font = .leo_medium15()
        subtitleLabel.textColor = .leo_gray176()

        submitButton.titleLabel?.font = .leo_demiBold12()
        submitButton.titleLabel?.font = .leo_demiBold12()

        configure()
    }

    private func configure() {
        configureNavigationBar()

        titleLabel.text = "Good stuff. Thanks for completing your child's assessment."
        subtitleLabel.text = "Your answers are being submitted to your pediatrician and will be reviewed with you at your next visit."
        submitButton.titleLabel?.text = "Fini!"
        iconView.image = surveyFinishedIcon
        submitButton.backgroundColor = .leo_orangeRed()
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.titleLabel?.font = .leo_medium12()
    }

    fileprivate func configureNavigationBar() {
        LEOStyleHelper.styleNavigationBar(for: self, for: .PHR, withTitleText: surveyName, dismissal: false, backButton: true)
    }

    @IBAction private func didTapSubmit(sender: UIButton) {
        routeDismissExpandedCard?()
    }
}
